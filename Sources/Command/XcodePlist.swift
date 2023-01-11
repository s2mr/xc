import Foundation

struct XcodeVersionPlist: Decodable {
    enum CodingKeys: String, CodingKey {
        case shortVersion = "CFBundleShortVersionString"
        case build = "ProductBuildVersion"
    }

    var shortVersion: String
    var build: String
}

extension XcodeVersionPlist {
    func version() throws -> Version {
        try Version(string: shortVersion)
    }
}
