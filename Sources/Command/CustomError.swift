struct CustomError: Error, CustomStringConvertible {
    var message: String

    var description: String { message }
}
