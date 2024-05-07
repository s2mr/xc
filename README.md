# xc
Open the Xcode project file with the specified version

## Usage

Open project file with preferred Xcode version:
```
xc
```

Open project file with Xcode 15.3.0:
```
xc -v 15.3.0
```

```
xc list

---
Available Xcode:
14.2    /Applications/Xcode.app         <xcode-select>
14.1    /Applications/Xcode14.1.app
13.4.1  /Applications/Xcode13.4.1.app
13.2.1  /Applications/Xcode13.2.1.app
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

### Show all Xcode list you installed

Automatically searching xcode via `NSWorkspace.shared.urlsForApplications(withBundleIdentifier: "com.apple.dt.Xcode")`.

```
xc list

---
Available Xcode:
14.2    /Applications/Xcode.app         <xcode-select>
14.1    /Applications/Xcode14.1.app
13.4.1  /Applications/Xcode13.4.1.app
13.2.1  /Applications/Xcode13.2.1.app
```

### Open Xcode.app without opening project

Simply run:
```
xc -n
```

### Automatically changing developer directory via xcode-select

When you execute `xc` or `xc open` command, automatically execute `sudo xcode-select --switch`.
This needs sudo password.
You can setting sudo password via `$ xc config`

> **Warning**
>
> This feature is disabled by default.
>
> You can enabled this feature by executing command below.
>
> `$ xc config write --sudo-password <sudo-password> --auto-xcode-select-enabled true`

### Command completion

This command is built on [swift-argument-parser](https://github.com/apple/swift-argument-parser).

Please refer to [this article](https://github.com/apple/swift-argument-parser/blob/main/Sources/ArgumentParser/Documentation.docc/Articles/InstallingCompletionScripts.md#installing-zsh-completions
).

Replace `example` with `xc`.

## Installation

### [Homebrew](https://brew.sh/)

```shell
brew install s2mr/tap/xc
```

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

## Help

```
xc --help

---
OVERVIEW: This tool launches the Xcode application and opens the given documents.

USAGE: xc <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  list                    Available Xcodes list
  open (default)          Shows available versions of Xcode
  config                  Read and write xc command config. Config json is stored at `~/.config/xc/config.json`
  env                     Current environment

  See 'xc help <subcommand>' for detailed help.
```

```
xc open --help

---
OVERVIEW: Shows available versions of Xcode

USAGE: xc open [-v <v>] [<path>]

ARGUMENTS:
  <path>                  File path

OPTIONS:
  -v <v>                  Open with specific Xcode version
  --version               Show the version.
  -h, --help              Show help information.
```
