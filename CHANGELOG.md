# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



## [Unreleased]



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
