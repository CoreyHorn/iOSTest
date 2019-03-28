import RxSwift
import RxCocoa
import Foundation

class Presenter<E: Event, A: Action, R: Result, S: State> {
    
    private var events: Observable<E>!
    
    var delegate: AnyPresenter<E, A, R, S>!{
        didSet { connectStreams() }
    }

    private let state = ReplaySubject<S>.create(bufferSize: 1)
    let actions = PublishSubject<A>()
    private let initialState: S
    
    //TODO: Logic will need to change when connecting / disconnecting the view
    private let eventBag = DisposeBag()

    private let resultBag = DisposeBag()
    
    init(events: Observable<E>, initialState: S) {
        self.events = events
        self.initialState = initialState
    }
    
    //TODO: Convert to connecting / disconnecting the view where appropriate
    func connectStreams() {
        checkPreReqs()
        
        self.events
            .map { self.delegate.eventToAction(event: $0) }
            .subscribe(actions)
            .disposed(by: eventBag)
        
        self.delegate.results()
            .scan(initialState, accumulator: self.delegate.accumulator)
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
}

protocol PresenterProtocol {
    associatedtype Event
    associatedtype Action
    associatedtype Result
    associatedtype State
    
    func eventToAction(event: Event) -> Action
    func accumulator(previousState: State, result: Result) -> State
    func events() -> Observable<Event>
    func states() -> Observable<State>
    func results() -> Observable<Result>
}

class AnyPresenter<E, A, R, S>: PresenterProtocol {
    private let _eventToAction: (_ event: E) -> A
    private let _accumulator: (_ previousState: S, _ result: R) -> S
    private let _events: () -> Observable<E>
    private let _states: () -> Observable<S>
    private let _results: () -> Observable<R>
    
    required init<U: PresenterProtocol>(_ presenterProtocol: U) where U.Event == E, U.Action == A, U.Result == R, U.State == S {
        _eventToAction = presenterProtocol.eventToAction
        _accumulator = presenterProtocol.accumulator
        _events = presenterProtocol.events
        _states = presenterProtocol.states
        _results = presenterProtocol.results
    }
    
    func eventToAction(event: E) -> A {
        return _eventToAction(event)
    }
    
    func accumulator(previousState: S, result: R) -> S {
        return _accumulator(previousState, result)
    }
    
    func events() -> Observable<E> {
        return _events()
    }
    
    func states() -> Observable<S> {
        return _states()
    }
    
    func results() -> Observable<R> {
        return _results()
    }
}
