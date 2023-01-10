import ArgumentParser

@main
struct MainTool: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xc",
        abstract: "This tool launches the Xcode application and opens the given documents.",
        version: "0.0.1",
        subcommands: [
            List.self,
            Open.self,
            ConfigCommand.self,
            Env.self
        ],
        defaultSubcommand: Open.self
    )
}
