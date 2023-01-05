import ArgumentParser

extension MainTool {
    struct ConfigCommand: ParsableCommand {
        struct Read: ParsableCommand {
            func run() throws {
                let config = try Config.get()
                print(config)
            }
        }

        struct Write: ParsableCommand {
            @Option
            var sudoPassword: String

            func run() throws {
                var config = try Config.get()
                config.sudoPassword = sudoPassword
                try config.write()
            }
        }

        static let configuration = CommandConfiguration(
            commandName: "config",
            abstract: "Read and write xc command config. Config json is stored at `~/.config/xc/config.json`",
            subcommands: [
                Read.self,
                Write.self
            ]
        )
    }
}
