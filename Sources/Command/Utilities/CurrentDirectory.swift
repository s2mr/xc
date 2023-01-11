import Foundation

enum CurrentDirectory {
    /// 1. xcworkspace
    /// 2. xcodeproj
    /// 3. Package.swift
    static func preferredProjectFileURL() throws -> URL? {
        if let url = try xcworkspaceURL() {
            return url
        }
        if let url = try xcodeprojURL() {
            return url
        }
        if let url = try packageSwiftURL() {
            return url
        }
        return nil
    }

    static var currentDirectoryURL: URL {
        URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    }

    static func xcworkspaceURL() throws -> URL? {
        let urls = try FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil)
        return urls.first(where: { $0.pathExtension == "xcworkspace" })
    }

    static func xcodeprojURL() throws -> URL? {
        let urls = try FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil)
        return urls.first(where: { $0.pathExtension == "xcodeproj" })
    }

    static func packageSwiftURL() throws -> URL? {
        let urls = try FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil)
        return urls.first(where: { $0.lastPathComponent == "Package.swift" })
    }

    static func xcodeVersion() throws -> Version? {
        let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/.xcode-version")
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        guard let versionString = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        return try Version(string: versionString)
    }
}
