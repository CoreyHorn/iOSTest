import RxSwift

class TimerService {
    let timerResults = Observable<Int>.timer(RxTimeInterval(1), period: RxTimeInterval(0.1), scheduler: MainScheduler.instance)
}
