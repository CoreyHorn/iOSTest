enum SimpleEvent: Event {
    case test(string: String)
}

enum SimpleResult: Result {
    case test(string: String)
}

struct SimpleState: State {
    var string: String
}
