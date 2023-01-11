import Foundation

struct Config {
    private static var applicationDirectoryURL: URL {
        return FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".config/xc")
    }
    private static var configURL: URL {
        applicationDirectoryURL
            .appendingPathComponent("config.json")
    }

    static func createIfNotFound() throws {
        let isExists = FileManager.default.fileExists(atPath: configURL.path)
        guard !isExists else { return }
        try FileManager.default.createDirectory(at: applicationDirectoryURL, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(Config())
        FileManager.default.createFile(atPath: configURL.path, contents: data)
    }

    static func get() throws -> Config {
        let data = try Data(contentsOf: configURL)
        return try JSONDecoder().decode(Config.self, from: data)
    }

    func write() throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: Self.configURL)
    }

    var sudoPassword: String = ""
    var autoXcodeSelectEnabled: Bool = false
}

extension Config: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sudoPassword = try container.decode(String.self, forKey: .sudoPassword)
        self.autoXcodeSelectEnabled = try container.decodeIfPresent(Bool.self, forKey: .autoXcodeSelectEnabled) ?? false
    }
}
