import RxSwift

class InputTimerInteractor: Interactor<InputTimerAction, InputTimerResult>, InteractorProtocol {
    
    let bag = DisposeBag()
    
    override init() {
        super.init()
        self.delegate = AnyInteractor(self)
    }
    
    override func connect(actions: Observable<InputTimerAction>) {
        super.connect(actions: actions)
        
        Services.instance.timerService.timerResults
            .map { InputTimerResult.NewTime(time: $0) }
            .subscribe(results)
            .disposed(by: bag)
    }
    
    func actionToResult(action: InputTimerAction) -> InputTimerResult {
        switch (action) {
        case .TextEntry(text: let text):
            return .NewText(text: text)
        }
    }
    
}
