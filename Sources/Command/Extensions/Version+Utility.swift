import Foundation

extension Version {
    init(string: String) throws {
        let components = string.split(separator: ".")
            .map(String.init)

        guard components.allSatisfy(\.isNumber) else {
            throw CustomError(message: "Invalid version: \(string)")
        }

        self.init(
            components[safe: 0].flatMap { Int($0) } ?? 0,
            components[safe: 1].flatMap { Int($0) } ?? 0,
            components[safe: 2].flatMap { Int($0) } ?? 0
        )
    }
}

private extension String {
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits
        return CharacterSet(charactersIn: self).isSubset(of: characters)
    }
}
