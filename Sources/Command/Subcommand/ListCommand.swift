import ArgumentParser
import AppKit

extension MainTool {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Available Xcodes list"
        )

        func run() throws {
            let xcodeSelectVersion = try Xcode.xcodeSelectVersion()
            let texts = try Xcode.availableApplicationURLs().map { url -> String in
                let plist = try Xcode.plist(atApplicationURL: url)
                let selectedText = try plist.version() == xcodeSelectVersion ? "<Selected>" : ""
                return "\(plist.shortVersion)\t\(url.path)\t\t\(selectedText)"
            }
            print("Available Xcode:")
            print(
                texts
                .joined(separator: "\n")
            )
        }
    }
}
