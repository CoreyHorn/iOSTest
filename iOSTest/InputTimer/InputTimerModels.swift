enum InputTimerEvent: Event {
    case TextEntry(text: String)
}

enum InputTimerAction: Action {
    case TextEntry(text: String)
}

enum InputTimerResult: Result {
    case NewText(text: String)
    case NewTime(time: Int)
}

struct InputTimerState: State {
    var text: String
    var time: Int
}
