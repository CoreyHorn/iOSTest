#!/usr/bin/swift
//
//  validate-headers.swift
//  scripts
//
//  Created by Krunoslav Zaher on 12/26/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

/**
 Validates that all headers are in this standard form

 //
 //  {file}.swift
 //  Project
 //
 //  Created by {Author} on 2/14/15.
 //  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
 //

 Only Project is not checked yet, but it will be soon.
 */

import Foundation

let fileManager = FileManager.default

let allowedExtensions = [
    ".swift",
    ".h",
    ".m",
]

let excludedRootPaths = [
    "Carthage",
    ".git",
    "build",
    "Rx.playground",
    "vendor",
    "Sources",
    "Carthage"
]

let excludePaths = [
    "AllTestz/main.swift",
    "Platform/AtomicInt.swift",
    "Platform/Platform.Linux.swift",
    "Platform/Platform.Darwin.swift",
    "Platform/RecursiveLock.swift",
    "Platform/DataStructures/Bag.swift",
    "Platform/DataStructures/InfiniteSequence.swift",
    "Platform/DataStructures/PriorityQueue.swift",
    "Platform/DataStructures/Queue.swift",
    "Platform/DispatchQueue+Extensions.swift",
    "Platform/DeprecationWarner.swift",
    "RxExample/Services/Reachability.swift",
    "RxDataSources"
]

func isExtensionIncluded(path: String) -> Bool {
    return (allowedExtensions.map { path.hasSuffix($0) }).reduce(false) { $0 || $1 }
}

let whitespace = NSCharacterSet.whitespacesAndNewlines

let identifier = "(?:\\w|\\+|\\_|\\.|-)+"

let fileLine = try NSRegularExpression(pattern: "//  (\(identifier))", options: [])
let projectLine = try NSRegularExpression(pattern: "//  (\(identifier))", options: [])

let createdBy = try NSRegularExpression(pattern: "//  Created by .* on \\d+/\\d+/\\d+\\.", options: [])
let copyrightLine = try NSRegularExpression(pattern: "//  Copyright © (\\d+) Krunoslav Zaher. All rights reserved.", options: [])

func validateRegexMatches(regularExpression: NSRegularExpression, content: String) -> ([String], Bool) {
    let range = NSRange(location: 0, length: content.count)
    let matches = regularExpression.matches(in: content, options: [], range: range)

    if matches.count == 0 {
        print("ERROR: line `\(content)` is invalid: \(regularExpression.pattern)")
        return ([], false)
    }

    for m in matches {
        if m.numberOfRanges == 0 || !NSEqualRanges(m.range, range) {
            print("ERROR: line `\(content)` is invalid: \(regularExpression.pattern)")
            return ([], false)
        }
    }

    return (matches[0 ..< matches.count].flatMap { m -> [String] in
        return (1 ..< m.numberOfRanges).map { index in
            let range = m.range(at: index)
            return (content as NSString).substring(with: range)
        }
    }, true)
}

func validateHeader(path: String) throws -> Bool {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

    let rawLines = contents.components(separatedBy: "\n")

    var lines = rawLines.map { $0.trimmingCharacters(in: whitespace) }

    if (lines.first ?? "").hasPrefix("#") || (lines.first ?? "").hasPrefix("// This file is autogenerated.") {
        lines.remove(at: 0)
    }

    if lines.count < 8 {
        print("ERROR: Number of lines is less then 8, so the header can't be correct")
        return false
    }

    for i in 0 ..< 7 {
        if !lines[i].hasPrefix("//") {
            print("ERROR: Line [\(i + 1)] (\(lines[i])) isn't prefixed with //")
            return false
        }
    }

    if lines[0] != "//" {
        print("ERROR: Line[1] First line should be `//`")
        return false
    }

    let (parsedFileLine, isValidFilename) = validateRegexMatches(regularExpression: fileLine, content: lines[1])

    if !isValidFilename {
        print("ERROR: Line[2] Filename line should match `\(fileLine.pattern)`")
        return false
    }

    let fileNameInFile = parsedFileLine.first ?? ""
    if fileNameInFile != (path as NSString).lastPathComponent {
        print("ERROR: Line[2] invalid file name `\(fileNameInFile)`, correct content is `\((path as NSString).lastPathComponent)`")
        return false
    }

    let (parsedProject, isValidProject) = validateRegexMatches(regularExpression: projectLine, content: lines[2])

    let targetProject = path.components(separatedBy: "/")[0]
    if !isValidProject || parsedProject.first != targetProject {
        print("ERROR: Line[3] Line not equal to `// \(targetProject)`")
        return false
    }

    if lines[3] != "//" {
        print("ERROR: Line[4] Line should be `//`")
        return false
    }

    let (_, isValidCreatedBy) = validateRegexMatches(regularExpression: createdBy, content: lines[4])

    if !isValidCreatedBy {
        print("ERROR: Line[5] Line not matching \(createdBy.pattern)")
        return false
    }

    let (year, isValidCopyright) = validateRegexMatches(regularExpression: copyrightLine, content: lines[5])

    if !isValidCopyright {
        print("ERROR: Line[6] Line not matching \(copyrightLine.pattern)")
        return false
    }

    let currentYear = Calendar.current.component(.year, from: Date())
    if year.first == nil || !(2015...currentYear).contains(Int(year.first!) ?? 0) {
        print("ERROR: Line[6] Wrong copyright year \(year.first ?? "?") instead of 2015...\(currentYear)")
        return false
    }

    if lines[6] != "//" {
        print("ERROR: Line[7] Line not matching \(copyrightLine.pattern)")
        return false
    }

    if lines[7] != "" {
        print("ERROR: Line[8] Should be blank and not `\(lines[7])`")
        return false
    }

    return true
}

func verifyAll(root: String) throws -> Bool {
    return try fileManager.subpathsOfDirectory(atPath: root).map { file -> Bool in
        let excluded = excludePaths.map { file.hasPrefix($0) }.reduce(false) { $0 || $1 }
        if excluded {
            return true
        }
        if !isExtensionIncluded(path: file) {
            return true
        }

        let isValid = try validateHeader(path: "\(root)/\(file)")
        if !isValid {
            print("     while Validating '\(root)/\(file)'")
        }

        return isValid
    }.reduce(true) { $0 && $1 }
}

let allValid = try fileManager.contentsOfDirectory(atPath: ".").map { rootDir -> Bool in
    if excludedRootPaths.contains(rootDir) {
        print("Skipping \(rootDir)")
        return true
    }
    return try verifyAll(root: rootDir)
}.reduce(true) { $0 && $1 }

if !allValid {
    exit(-1)
}
