import RxSwift

class SimplePresenter: Presenter<SimpleEvent, SimpleResult, SimpleState>, PresenterProtocol {
    
    func results() -> Observable<SimpleResult> {
        let interactor = SimpleInteractor()
        interactor.connect(events: events)
        return interactor.results
    }
    
    func resultToState(previousState: SimpleState, result: SimpleResult) -> SimpleState {
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
