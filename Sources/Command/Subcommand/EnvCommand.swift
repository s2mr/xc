import ArgumentParser

extension MainTool {
    struct Env: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Current environment"
        )

        func run() throws {
            let preferredVersion = try? Xcode.preferredVersion(userSpecifyVersion: nil)
            let xcodeVersion = try? CurrentDirectory.xcodeVersion()
            let xcodeSelectVersion = try? Xcode.xcodeSelectVersion()
            let dataSets = [
                VersionDataSet(name: ".xcode-version", version: xcodeVersion),
                VersionDataSet(name: " $xcode-select", version: xcodeSelectVersion),
            ]
            let preferredIndex = dataSets.firstIndex(where: { $0.version == preferredVersion })
            print("# Preferred Xcode version")
            dataSets.enumerated().forEach { index, dataSet in
                print("\(dataSet.name): \(dataSet.version?.description ?? "")\t\(index == preferredIndex ? "<Preferred>" : "")")
            }
            print()

            print("# Preferred project file")
            let preferredProjectFileURL = try CurrentDirectory.preferredProjectFileURL()
            if preferredProjectFileURL.isNone {
                return print("Project file not found in current directory.")
            }

            let xcworkspaceURL = try? CurrentDirectory.xcworkspaceURL()
            let xcodeprojURL = try? CurrentDirectory.xcodeprojURL()
            let packageSwiftURL = try? CurrentDirectory.packageSwiftURL()
            print(" .xcworkspace: \(xcworkspaceURL?.lastPathComponent ?? "")\t\(xcworkspaceURL == preferredProjectFileURL ? "<Preferred>" : "")")
            print("   .xcodeproj: \(xcodeprojURL?.lastPathComponent ?? "")\t\(xcodeprojURL == preferredProjectFileURL ? "<Preferred>" : "")")
            print("Package.swift: \(packageSwiftURL?.lastPathComponent ?? "")\t\(packageSwiftURL == preferredProjectFileURL ? "<Preferred>" : "")")

            print()
            print("# xcode-select --print-path")
            let result = Bash.launchSync("xcode-select --print-path")
            print("Version:", xcodeVersion ?? "")
            print(" Result:", result.standardOutput.string() ?? "")
        }
    }
}

private struct VersionDataSet {
    var name: String
    var version: Version?
}
