import Foundation

extension FileHandle {
    func print() {
        guard let string = string(), !string.isEmpty else { return }
        Swift.print(string)
    }

    func string() -> String? {
        let data = readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
