import RxSwift

class InputTimerInteractor: Interactor<InputTimerEvent, InputTimerResult>, InteractorProtocol {
    
    let bag = DisposeBag()
    
    override init() {
        super.init()
        self.delegate = AnyInteractor(self)
    }
    
    override func connect(events: Observable<InputTimerEvent>) {
        super.connect(events: events)
        
        Services.instance.timerService.timerResults
            .map { InputTimerResult.NewTime(time: $0) }
            .subscribe(results)
            .disposed(by: bag)
    }
    
    func eventToResult(event: InputTimerEvent) -> InputTimerResult {
        switch (event) {
        case .TextEntry(text: let text):
            return .NewText(text: text)
        }
    }
    
}
