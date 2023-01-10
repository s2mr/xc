# xc (EXPERIMENTAL)
Open your xcode project with Xcode of specific version.

## Examples

```
$ xc -v 14.2.0 # Open project file with Xcode 14.2.0
```

```
xc > xc list
Available Xcode:
14.2    /Applications/Xcode.app         <Selected>
14.1    /Applications/Xcode14.1.app
13.4.1  /Applications/Xcode13.4.1.app
13.2.1  /Applications/Xcode13.2.1.app
```

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the following to the dependencies of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/s2mr/xc.git", from: "xc version"),
]
```

Run command:

```sh
swift run -c release xc [COMMAND] [OPTIONS]
```

### [Mint](https://github.com/yonaskolb/Mint)

Install with Mint by following command:

```sh
mint install s2mr/xc
```

Run command:

```sh
mint run s2mr/xc [COMMAND] [OPTIONS]
```

### Using a pre-built binary

You can also install xc by downloading `xc.zip` from the latest GitHub release.

## Setup

This command's automatically changing xcode-select path feature needs sudo password.

Please set password via below command.

```
$ xc config write --sudo-password `<Your password here>`
```

Or, you can disable this feature via below command.

```
$ xc config write --auto-xcode-select-enabled false
```

## Feature
### Automatic project file searching (priority)
1. User specified path <Optional arguments>
2. `.xcworkspace`
3. `.xcodeproj`
4. `Package.swift`

### Automatic Xcode version searching (priority)
1. User specified version <Optional options>
2. `.xcode-version` <Optional file>
3. `$ xcode-select`

## Help

```
$ xc --help
USAGE: xc <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  list                    Available Xcodes list
  open (default)          Shows available versions of Xcode
  config                  Read and write xc command config. Config json is stored at `~/.config/xc/config.json`
```

```
$ xc open --help
OVERVIEW: Shows available versions of Xcode

USAGE: xc open [-v <v>] [<path>]

ARGUMENTS:
  <path>                  File path

OPTIONS:
  -v <v>                  Open with specific Xcode version
  --version               Show the version.
  -h, --help              Show help information.
```
