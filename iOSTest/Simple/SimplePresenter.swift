import RxSwift

class SimplePresenter: Presenter<SimpleEvent, SimpleAction, SimpleResult, SimpleState>, PresenterProtocol {
    
    func results() -> Observable<SimpleResult> {
        let interactor = SimpleInteractor()
        interactor.connect(actions: actions)
        return interactor.results
    }
    
    func eventToAction(event: SimpleEvent) -> SimpleAction {
        switch (event) {
        case SimpleEvent.test(string: let eventString):
            return .test(string: eventString)
        }
    }
    
    func accumulator(previousState: SimpleState, result: SimpleResult) -> SimpleState {
        switch (result) {
        case SimpleResult.test(string: let resultString):
            return SimpleState(string: resultString)
        }
    }
    
    override init(events: Observable<SimpleEvent>, initialState: SimpleState) {
        super.init(events: events, initialState: initialState)
        delegate = AnyPresenter(self)
    }
}
