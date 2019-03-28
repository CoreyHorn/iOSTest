import Foundation
import UIKit

class SimpleViewController: PresenterView<SimpleEvent, SimpleAction, SimpleResult, SimpleState>, PresenterViewProtocol {
    
    func getPresenter() -> AnyPresenter<SimpleEvent, SimpleAction, SimpleResult, SimpleState> {
        return AnyPresenter(SimplePresenter(events: events, initialState: SimpleState(string: "initial state")))
    }
    
    func renderState(state: SimpleState) {
        NSLog("State: " + state.string)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        events.onNext(.test(string: "event one"))
        events.onNext(.test(string: "event two"))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = AnyPresenterView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = AnyPresenterView(self)
    }
}
