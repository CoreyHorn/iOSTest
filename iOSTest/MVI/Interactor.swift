import RxSwift
import RxCocoa

class Interactor<E: MVIEvent, R: MVIResult> {
    
    let results = PublishSubject<R>()
    
    var delegate: AnyInteractor<E, R>!
    
    private let bag = DisposeBag()
    
    func connect(events: Observable<E>) {
        checkPreReqs()
        
        events.map { self.delegate.eventToResult(event: $0) }
            .subscribe(results)
            .disposed(by: bag)
    }
    
    private func checkPreReqs() {
        if (delegate == nil) {
            NSLog("Delegate is nil. Make sure to set self.delegate in all Interactor init functions.")
        }
    }
}

protocol InteractorProtocol{
    associatedtype Event
    associatedtype Result
    
    func eventToResult(event: Event) -> Result
}

class AnyInteractor<E, R>: InteractorProtocol {
    
    private let _eventToResult: (_ event: E) -> R
    
    required init<I: InteractorProtocol>(_ interactor: I) where I.Event == E, I.Result == R {
        _eventToResult = interactor.eventToResult
    }
    
    func eventToResult(event: E) -> R {
        return _eventToResult(event)
    }
}
