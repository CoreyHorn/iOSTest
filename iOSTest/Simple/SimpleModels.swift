enum SimpleEvent: MVIEvent {
    case test(string: String)
}

enum SimpleResult: MVIResult {
    case test(string: String)
}

struct SimpleState: MVIState {
    var string: String
}
