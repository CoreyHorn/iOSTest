//
//  SimpleInteractor.swift
//  iOSTest
//
//  Created by Corey Horn on 2/26/19.
//  Copyright © 2019 Snag. All rights reserved.
//

import UIKit
import RxSwift

class SimpleInteractor: Interactor<SimpleAction, SimpleResult>, InteractorProtocol {
    
    override init() {
        super.init()
        self.delegate = AnyInteractor(self)
    }
    
    func actionToResult(action: SimpleAction) -> SimpleResult {
        switch (action) {
        case .test(string: let actionString):
            return .test(string: actionString)
        }
    }
}
