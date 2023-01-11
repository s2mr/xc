extension Optional {
    var isNone: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}
