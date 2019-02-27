import RxSwift
import UIKit

class PresenterView<E: Event, A: Action, R: Result, S: State>: UIViewController {
    
    var delegate: AnyPresenterView<E, A, R, S>! 
    let events = ReplaySubject<E>.createUnbounded()
    let bag = DisposeBag()
    
    var presenter: AnyPresenter<E, A, R, S>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPreReqs()
        presenter = delegate.getPresenter()
        presenter.states()
            .subscribe(onNext: { self.delegate.renderState(state: $0) })
            .disposed(by: bag)
    }
    
    private func checkPreReqs() {
        if (delegate == nil) {
            NSLog("Delegate is nil. Make sure to set self.delegate in all viewcontroller init functions.")
        }
    }
}

protocol PresenterViewProtocol{
    associatedtype Event
    associatedtype Action
    associatedtype Result
    associatedtype State
    
    func getPresenter() -> AnyPresenter<Event, Action, Result, State>
    func renderState(state: State)
}

class AnyPresenterView<E, A, R, S>: PresenterViewProtocol {
    
    private let _getPresenter: () -> AnyPresenter<E, A, R, S>
    private let _renderState: (_ state: S) -> ()
    
    required init<U: PresenterViewProtocol>(_ presenterView: U) where U.Event == E, U.Action == A,
                                                                        U.Result == R, U.State == S {
        _getPresenter = presenterView.getPresenter
        _renderState = presenterView.renderState
    }
    
    func getPresenter() -> AnyPresenter<E, A, R, S> {
        return _getPresenter()
    }
    
    func renderState(state: S) {
        return _renderState(state)
    }
}
