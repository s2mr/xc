import Foundation

extension FileHandle {
    func print() {
        guard let string = string(), !string.isEmpty else { return }
        Swift.print(string)
    }

    func string() -> String? {
        try? seek(toOffset: 0)
        let data = readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
