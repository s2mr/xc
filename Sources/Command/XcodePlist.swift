import Foundation

struct XcodePlist: Decodable {
    enum CodingKeys: String, CodingKey {
        case shortVersion = "CFBundleShortVersionString"
    }

    var shortVersion: String
}

extension XcodePlist {
    func version() throws -> Version {
        try Version(string: shortVersion)
    }
}

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

struct CustomError: Error, CustomStringConvertible {
    var message: String

    var description: String { message }
}
