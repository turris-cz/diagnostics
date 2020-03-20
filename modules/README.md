Turris diagnostics
==================

Modules
-------

Each *diagnostics module* must be named like `[a-zA-z_]+.module` and it should
contain:

```
#!modules/module.sh

help="
$(gettext "Some brief description of the module.")
"

run () {
	# the actual code with prints something into stdout/stderr
}
```
