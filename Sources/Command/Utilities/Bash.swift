import Foundation

enum Bash {
    struct LaunchResult {
        var process: Process
        var standardOutput: FileHandle
        var standardError: FileHandle
    }

    static func launchSync(_ command: String) -> LaunchResult {
        let task = Process()
        let standardOutput = Pipe()
        let standardError = Pipe()

        task.standardOutput = standardOutput
        task.standardError = standardError
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.standardInput = nil
        task.launch()
        task.waitUntilExit()

        return LaunchResult(
            process: task,
            standardOutput: standardOutput.fileHandleForReading,
            standardError: standardError.fileHandleForReading
        )
    }
}
