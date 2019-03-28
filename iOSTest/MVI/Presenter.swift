import RxSwift
import RxCocoa
import Foundation

class Presenter<E: Event, R: Result, S: State> {
    
    var delegate: AnyPresenter<E, R, S>!{
        didSet { connectStreams() }
    }
    
    var events: Observable<E>!
    
    init(events: Observable<E>, initialState: S) {
        self.events = events
        self.initialState = initialState
    }
    
    func connectStreams() {
        checkPreReqs()
        
        self.delegate.results()
            .scan(initialState, accumulator: self.delegate.resultToState)
            .startWith(initialState)
            .subscribe(state)
            .disposed(by: resultBag)
    }
    
    func states() -> Observable<S> {
        return state
    }
    
    private func checkPreReqs() {
        if (delegate == nil) {
            NSLog("Delegate is nil. Make sure to set self.delegate in all Presenter init functions.")
        }
    }
    
    private let state = ReplaySubject<S>.create(bufferSize: 1)
    private let initialState: S
    private let resultBag = DisposeBag()
}

protocol PresenterProtocol {
    associatedtype Result
    associatedtype State
    
    func states() -> Observable<State>
    func results() -> Observable<Result>
    
    func resultToState(previousState: State, result: Result) -> State
}

class AnyPresenter<E, R, S>: PresenterProtocol {
    private let _states: () -> Observable<S>
    private let _results: () -> Observable<R>
    private let _resultToState: (_ previousState: S, _ result: R) -> S
    
    required init<U: PresenterProtocol>(_ presenterProtocol: U) where U.Result == R, U.State == S {
        _resultToState = presenterProtocol.resultToState
        _states = presenterProtocol.states
        _results = presenterProtocol.results
    }
    
    func states() -> Observable<S> {
        return _states()
    }
    
    func results() -> Observable<R> {
        return _results()
    }
    
    func resultToState(previousState: S, result: R) -> S {
        return _resultToState(previousState, result)
    }
}
