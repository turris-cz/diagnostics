# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `uci_anonymize` function that replaces UCI value with asterisks. It is a way to
  include option in report without getting the real value.
- Notification module's UCI configuration
- (re)Foris module
- Sentinel module
- HaaS module
- opkg configuration to package module
- firmare (uboot) module now queries also for versions of U-Boot, rescue image and
  secure firmware

### Changed

- Key in wireless configuration is now anonymized instead of being filtered out
- Wireguard's private key and preshared keys are now anynimized
- PPPoE password is now anonymized
- serial-number, os-release, uname and uptime modules were merged to single
  system-info module
- netstat module now uses `ss` instead of `netstat` and thus provides even more
  info and was renamed to `sockets`
- utility function `dump_file` now support multiple files (intended to be used
  with globs)
- module uboot renamed to firmware

### Fixed

- `ps` command in dns module is now explicitly busybox implementation

### Removed

- nikola module


## [13.1.2] - 2021-01-25

### Changed

- `lspci` expanded to show also vendor and device numbers and names

### Fixed

- `nikola` fixed to call `sentinel-nikola` instead of `nikola`


## [13.1.1] - 2020-12-07

### Added

- `updater` module now also prints pkglists

### Fixed

- Ignored command line options when background mode was used


## [13.1] - 2020-10-28

### Added

- `dns` module: Mark resolution attempts with their meaning and desired results

### Changed

- `dns` module: Update list of domain names for resolution attempts
- Update Norwegian translations


## [13.0.0] - 2020-10-05

### Added

- Help text can be now invoked not only by `help` but also using `-h`
- Porcelain output for listing modules introduced with `-l` argument switch
- Read syslog messages from permanent storage (/srv/log/messages)
- DHCP diagnostics
- Additional DNS diagnostics for forwarders and Knot-resolver config

### Changed

- Order numbers are now not part of module name but rather required and stripped
  part of module naming scheme
- Diagnostics script now exits with non-zero exit code when no output was
  generated when module execution is performed
- Help text now prints and script exits before fork to background when `-b`
  argument is used.
- `getopts` based argument parsing is not utilized allowing user to provide
  argument switches in any order and in more standard way
- Usage is now printed when invalid usage of script is detected
- Overall code cleanup

### Removed

- Virtual module `help` as now help can be obtained with `-h` switch


## [12.3.1] - 2020-09-25

### Changed

- Update translations


## [12.3] - 2020-09-25

### Changed

- Fix compatibility with a newer version of kresd in `dns` module


## [12.2] - 2020-05-04

### Changed

- Close *stdin* when running modules
- Improve `os_release` module error handling
- Update translations


## [12.1] - 2020-05-04

### Changed

- Improve `date` module, add country and timezone info


## [12.0] - 2020-05-03

### Added

- Add new module to create and send user notification
- Add new module to run Sentinel:Certgen

### Changed

- Run modules in given order by prepend their names with numbers
- Refactor and add common modules functions
- `updater` module
    - Include UCI config in diagnostics
    - Improve shell code
- `os_release` module
    - Fix for latest OpenWrt release
    - Improve shell code
- `messages` module
    - Shell refactoring
- `dns` module
    - Fix shell quoting and output format
    - Update list of Turris domains


## [11.6] - 2020-04-19

### Changed

- Fix `os_release` module


## [11.5] - 2020-04-11

### Changed

- Fix `nikola` module
- Refactor modules sections


## [11.4] - 2020-03-09

### Changed

- Improve `cron` module
- Update translations


## [11.3] - 2020-03-07

### Changed

- Synchronize module description
- Update translations


## [11.2] - 2019-10-23

### Added

- Set `TEXTDOMAINDIR` for l10n


## [11.1] - 2019-10-23

### Changed

- Fix Makefile
- Update translations


## [11.0] - 2019-10-17

### Added

- l10n support


## [10.1] - 2019-05-06

### Changed

- Fix `turris_webs` module


## [10.0] - 2019-04-23

### Changed

- Compatibility with Turris OS 4.0
