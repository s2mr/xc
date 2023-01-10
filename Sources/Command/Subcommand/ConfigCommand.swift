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
            enum WriteError: Error, CustomStringConvertible {
                case valueUnspecified

                var description: String {
                    switch self {
                    case .valueUnspecified:
                        return "Please pass one or more values."
                    }
                }
            }

            @Option
            var sudoPassword: String?

            @Option
            var autoXcodeSelectEnabled: Bool?

            func run() throws {
                let isValueUnspecified = [
                    sudoPassword.isNone,
                    autoXcodeSelectEnabled.isNone
                ].allSatisfy { $0 }

                if isValueUnspecified {
                    throw WriteError.valueUnspecified
                }

                var config = try Config.get()
                if let sudoPassword {
                    config.sudoPassword = sudoPassword
                }
                if let autoXcodeSelectEnabled {
                    config.autoXcodeSelectEnabled = autoXcodeSelectEnabled
                }
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

extension Optional {
    var isNone: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}
