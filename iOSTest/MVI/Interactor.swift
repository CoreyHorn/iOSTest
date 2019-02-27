//
//  Interactor.swift
//  iOSTest
//
//  Created by Corey Horn on 2/26/19.
//  Copyright © 2019 Snag. All rights reserved.
//
import RxSwift
import RxCocoa

class Interactor<A: Action, R: Result> {
    
    let results = PublishSubject<R>()
    
    var delegate: AnyInteractor<A, R>!
    
    private let actionBag = DisposeBag()
    
    func connect(actions: Observable<A>) {
        checkPreReqs()
        
        actions.map { self.delegate.actionToResult(action: $0) }
            .subscribe(results)
            .disposed(by: actionBag)
    }
    
    private func checkPreReqs() {
        if (delegate == nil) {
            NSLog("Delegate is nil. Make sure to set self.delegate in all Interactor init functions.")
        }
    }
    
}

protocol InteractorProtocol{
    associatedtype Action
    associatedtype Result
    
    func actionToResult(action: Action) -> Result
    
}

class AnyInteractor<A, R>: InteractorProtocol {
    
    private let _actionToResult: (_ action: A) -> R
    
    required init<I: InteractorProtocol>(_ interactor: I) where I.Action == A, I.Result == R {
        _actionToResult = interactor.actionToResult
    }
    
    func actionToResult(action: A) -> R {
        return _actionToResult(action)
    }

}
