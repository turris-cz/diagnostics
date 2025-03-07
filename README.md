# Turris diagnostics

Diagnostic scripts to be executed on Turris router generating text report.

Diagnostics are divided to modules. New modules can be implemented in modules
directory. Read README file in modules directory for more on how to create
modules.

## Dependencies

The following commands have to be installed for correct diagnostics
functionality on top of at minimum ash as shell interpretor with common shell
scripting tools (such as `sed` or `awk`):

- mount and umount
- tar
- uci
- md5sum
- strings
- fw_printenv
- lzcat
- lsusb
- lspci
- sensors
- hwinfo
- lsblk
- df
- du
- ubus
- busybox
- pstree
- dig
- ss
- iptables-save
- opkg
- pkgupdate
- curl
- lighttpd
- create_notification
- dmesg
- ethtool
- hexdump

There are other optional commands that are used when specific software is
installed but they are tied to that specific software and are not general
diagnostics tools.

## Localization

This command should be localized. To test it you can run

```bash
make install  # installs localization
LANGUAGE=cs ./diagnostics.sh help
```

To update messages you can simply call

```bash
make update
```

Do not forget to call this command when you add new or modify existing "gettext"
strings.

Note that the translations are supposed to be edited using weblate and merged
backwards afterwards. See `turris-translations` repository for details.
