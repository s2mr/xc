import ArgumentParser
import Foundation

private enum OpenError: Error, CustomStringConvertible {
    case xcodeURLNotFound(version: Version?)
    case sudoPasswordEmpty
    case internalError
    case preferredFileNotFound

    var description: String {
        switch self {
        case .xcodeURLNotFound(.some(let version)):
            return "Xcode is not found for version: \(version)."
        case .xcodeURLNotFound(nil):
            return "Xcode is not found."
        case .sudoPasswordEmpty:
            return "This command needs sudo password.\nPlease set password by executing `xc config write --sudo-password=<Your Password>`."
        case .internalError:
            return "Internal error"
        case .preferredFileNotFound:
            return "Project file not found."
        }
    }
}

extension MainTool {
    struct Open: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Shows available versions of Xcode"
        )

        @Option(
            name: .shortAndLong,
            help: "Open with specific Xcode version",
            completion: .list((try? Xcode.availableVersions()) ?? [])
        )
        var version: String?

        @Flag(
            name: .shortAndLong,
            help: "Only open Xcode without specific file path."
        )
        var nope: Bool = false

        @Argument(
            help: "File path",
            completion: .file()
        )
        var path: String?

        func run() throws {
            let preferredVersion = try Xcode.preferredVersion(userSpecifyVersion: version)

            let xcodeURL: URL? = try {
                let availableXcodeURLs = Xcode.availableApplicationURLs()
                guard let preferredVersion else {
                    return availableXcodeURLs.first(where: { $0.lastPathComponent == "Xcode.app" })
                        ?? availableXcodeURLs.first
                }

                return try availableXcodeURLs.first { url in
                    let plist = try Xcode.plist(atApplicationURL: url)
                    let preferredVersion = preferredVersion
                    return try Version(string: plist.shortVersion) == preferredVersion
                }
            }()

            guard let xcodeURL else {
                throw OpenError.xcodeURLNotFound(version: preferredVersion)
            }

            try Config.createIfNotFound()
            let config = try Config.get()

            var isXcodeSelectExecuted = false
            if config.autoXcodeSelectEnabled {
                if config.sudoPassword.isEmpty {
                    throw OpenError.sudoPasswordEmpty
                }

                let result = Bash.launchSync("echo \(config.sudoPassword) | sudo -S xcode-select --switch \(xcodeURL.path)")
                if result.process.terminationStatus != 0 {
                    throw CustomError(message: result.standardError.string() ?? "")
                }
                isXcodeSelectExecuted = true
            }

            var fileURL: URL?
            if !nope {
                if let path {
                    fileURL = URL(fileURLWithPath: path)
                }
                else {
                    fileURL = try CurrentDirectory.preferredProjectFileURL()
                }
                if fileURL.isNone {
                    throw OpenError.preferredFileNotFound
                }
            }

            let result = Bash.launchSync("open -a \(xcodeURL.path) \(fileURL?.path ?? "")")
            if result.process.terminationStatus != 0 {
                throw CustomError(message: result.standardError.string() ?? "")
            }

            let openedXcodeVersion = try Xcode.plist(atApplicationURL: xcodeURL).version()

            if let fileURL {
                print("Open: \(fileURL.lastPathComponent)")
                print("With: Xcode \(openedXcodeVersion) (\(xcodeURL.path))")
            }
            else {
                print("Open: Xcode \(openedXcodeVersion) (\(xcodeURL.path))")
            }

            if isXcodeSelectExecuted {
                let result = Bash.launchSync("xcode-select --print-path")

                if result.process.terminationStatus != 0 {
                    throw CustomError(message: result.standardError.string() ?? "")
                }

                let developerDir = result.standardOutput.string()?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                print("Developer directory has changed to: \(developerDir)")
            }
        }
    }
}

private extension URL {
    func schemeRemoved() -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.scheme = nil
        return components.url
    }
}
