import UIKit
import RxSwift

class InputTimerViewController: PresenterView<InputTimerEvent, InputTimerAction, InputTimerResult, InputTimerState>, PresenterViewProtocol {
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var lastTextEntered: UILabel!
    
    @IBAction func textChanged(_ sender: UITextField) {
        let text = sender.text
        if (text != nil) {
            events.onNext(.TextEntry(text: text!))
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = AnyPresenterView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = AnyPresenterView(self)
    }
    
    func getPresenter() -> AnyPresenter<InputTimerEvent, InputTimerAction, InputTimerResult, InputTimerState> {
        return AnyPresenter(InputTimerPresenter(events: events,
                                                initialState: InputTimerState(text: "Enter Some Text Below", time: 0)))
    }
    
    func renderState(state: InputTimerState) {
        currentTime.text = String(state.time)
        lastTextEntered.text = state.text
    }
}
