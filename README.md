# xc (EXPERIMENTAL)
Open your xcode project with Xcode of specific version.

## Setup

This command needs sudo password.

Please set password via below command.

```
$ xc config write --sudo-password `<Your password here>`
```

Or, please create PR to fixup🙇‍♂️

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