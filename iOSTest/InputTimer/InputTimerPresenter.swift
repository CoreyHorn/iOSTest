import RxSwift
import Foundation

class InputTimerPresenter: Presenter<InputTimerEvent, InputTimerResult, InputTimerState>, PresenterProtocol {
    
    func resultToState(previousState: InputTimerState, result: InputTimerResult) -> InputTimerState {
        switch (result) {
        case .NewText(text: let text):
            return InputTimerState(text: text, time: previousState.time)
            
        case .NewTime(time: let time):
            return InputTimerState(text: previousState.text, time: time)
        }
    }
    
    func results() -> Observable<InputTimerResult> {
        let interactor = InputTimerInteractor()
        interactor.connect(events: events)
        return interactor.results
    }
    
    override init(events: Observable<InputTimerEvent>, initialState: InputTimerState) {
        super.init(events: events, initialState: initialState)
        
        /* This is here to show how the presenter is able to filter events
        before forwarding to the presenter. This could allow for checking
        the current state and conditionally forwarding / modifying the event.
        This should be done before delegate is set or the changes won't be applied.*/
        
        //Uncommenting the line below will mean no events reach the interactor
        //self.events = events.filter { _ in return false }
        
        delegate = AnyPresenter(self)
    }
}
