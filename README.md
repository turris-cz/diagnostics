Turris diagnostics
==================
Diagnostic scripts to be executed on Turris router generating text report.

Diagnostics are divided to modules. New modules can be implemented in modules
directory. Read README file in modules directory for more on how to create
modules.

Localization
------------

This command should be localized. To test it you can run
```bash
make install  # installs localization
LANGUAGE=cs ./diagnostics.sh help

```

To update messages you can simply call
```bash
make messages
```

Note that the translations are supposed to be edited using weblate and merged backwards afterwards.
See `turris-translations` repository for details.
