import AppKit

enum Xcode {
    static func availableApplicationURLs() -> [URL] {
        NSWorkspace.shared.urlsForApplications(withBundleIdentifier: "com.apple.dt.Xcode")
    }

    static func availableVersions() throws -> [String] {
        return try availableApplicationURLs().map { url -> String in
            let plist = try Xcode.plist(atApplicationURL: url)
            return plist.shortVersion
        }
    }

    static func plist(atApplicationURL url: URL) throws -> XcodePlist {
        let plistURL = url.appendingPathComponent("Contents/Info.plist")
        let data = try Data(contentsOf: plistURL)
        return try PropertyListDecoder().decode(XcodePlist.self, from: data)
    }

    /// Get preferred versions for opening Xcode.
    /// Priority ↓
    /// 1. -v options
    /// 2. .xcode-version
    /// 3. xcode-select version
    static func preferredVersion(userSpecifyVersion version: String?) throws -> Version? {
        if let commandLineVersion = try version.map({ try Version(string: $0) }) {
            return commandLineVersion
        }
        if let xcodeVersion = try CurrentDirectory.xcodeVersion() {
            return xcodeVersion
        }
        if let xcodeSelectVersion = try xcodeSelectVersion() {
            return xcodeSelectVersion
        }
        return nil
    }

    static func xcodeSelectVersion() throws -> Version? {
        // e.g.
        //   - `/Applications/Xcode.app/Contents/Developer`
        //   - `/Library/Developer/CommandLineTools`

        let result = Bash.launchSync("xcode-select --print-path")
        guard result.process.terminationStatus == 0,
              let path = result.standardOutput.string() else {
            throw CustomError(message: result.standardError.string() ?? "")
        }

        let developerDirectoryURL = URL(fileURLWithPath: path)
        if developerDirectoryURL.lastPathComponent == "CommandLineTools" {
            return nil
        }

        let applicationURL = developerDirectoryURL.deletingLastPathComponent().deletingLastPathComponent()
        let shortVersion = try Xcode.plist(atApplicationURL: applicationURL).shortVersion
        return try Version(string: shortVersion)
    }
}
