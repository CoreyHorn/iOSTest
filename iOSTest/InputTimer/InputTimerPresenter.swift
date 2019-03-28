import RxSwift
import Foundation

class InputTimerPresenter: Presenter<InputTimerEvent, InputTimerAction, InputTimerResult,InputTimerState>, PresenterProtocol
{
    func eventToAction(event: InputTimerEvent) -> InputTimerAction {
        switch (event) {
        case .TextEntry(text: let text):
            return .TextEntry(text: text)
        }
    }
    
    func accumulator(previousState: InputTimerState, result: InputTimerResult) -> InputTimerState {
        switch (result) {
        case .NewText(text: let text):
            return InputTimerState(text: text, time: previousState.time)
            
        case .NewTime(time: let time):
            return InputTimerState(text: previousState.text, time: time)
        }
    }
    
    
    func results() -> Observable<InputTimerResult> {
        let interactor = InputTimerInteractor()
        interactor.connect(actions: actions)
        return interactor.results
    }
    
    override init(events: Observable<InputTimerEvent>, initialState: InputTimerState) {
        super.init(events: events, initialState: initialState)
        delegate = AnyPresenter(self)
    }
}
