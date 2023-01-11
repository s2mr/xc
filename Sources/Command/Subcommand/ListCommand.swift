import ArgumentParser
import AppKit

extension MainTool {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Available Xcodes list"
        )

        func run() throws {
            let xcodeSelectVersion = try Xcode.xcodeSelectVersion()
            let texts = try Xcode.availableApplicationURLs()
                .map {
                    DataSet(
                        xcodeURL: $0,
                        plist: try Xcode.plist(atApplicationURL: $0)
                    )
                }
                .sorted(by: { try $0.plist.version() > $1.plist.version() })
                .map { dataSet -> String in
                    let plist = dataSet.plist
                    let selectedText = try plist.version() == xcodeSelectVersion ? "<xcode-select>" : ""
                    let shortVersion = plist.shortVersion.rightPadding(toLength: 6, withPad: " ")
                    let build = "(\(plist.build))".leftPadding(toLength: 8, withPad: " ")
                    return "\(shortVersion)\t\(build)\t\(dataSet.xcodeURL.path)\t\t\(selectedText)"
                }
            print("Available Xcode:")
            print(
                texts
                .joined(separator: "\n")
            )
        }
    }
}

private struct DataSet {
    var xcodeURL: URL
    var plist: XcodeVersionPlist
}
