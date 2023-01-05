import Foundation

enum Bash {
    #warning("TODO: return Process") 
    static func launch(_ command: String) -> FileHandle {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.standardInput = nil
        task.launch()

        return pipe.fileHandleForReading
    }
}
