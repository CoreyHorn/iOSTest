import Foundation

class Services {
    
    static let instance = Services()
    
    let timerService = TimerService()
    
    private init() {}
}
