import UIKit
import RxSwift

class SimpleInteractor: Interactor<SimpleEvent, SimpleResult>, InteractorProtocol {
    
    override init() {
        super.init()
        self.delegate = AnyInteractor(self)
    }
    
    func eventToResult(event: SimpleEvent) -> SimpleResult {
        switch (event) {
        case .test(string: let actionString):
            return .test(string: actionString)
        }
    }
}
