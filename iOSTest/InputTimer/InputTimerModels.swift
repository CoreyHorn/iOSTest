enum InputTimerEvent: MVIEvent {
    case TextEntry(text: String)
}

enum InputTimerResult: MVIResult {
    case NewText(text: String)
    case NewTime(time: Int)
}

struct InputTimerState: MVIState {
    var text: String
    var time: Int
}
