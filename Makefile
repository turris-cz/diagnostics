MAKEFLAGS += --no-builtin-rules

LANGS:=$(shell find locale -name turris-diagnostics.po | cut -d '/' -f 2)
MO:=$(patsubst %.po,%.mo,$(shell find -name turris-diagnostics.po))

.PHONY: all
all: $(MO)
	@

.PHONY: clean
clean:
	rm -f $(MO)

.PHONY: install
install:
	@

.PHONY: update
update:
	@

.PHONY: help
help:
	@echo 'Top level targets:'
	@echo '  all: generate *.mo files'
	@echo '  clean: remove generated *.mo files'
	@echo '  install: copy *.mo files to $(DESTDIR)/usr/share/locale/'
	@echo '  update: extract strings and merge changes from *.pot file to *.po files'


$(MO): %.mo: %.po
	msgfmt --output-file=$@ $<

locale/turris-diagnostics.pot: diagnostics.sh modules/*.module
	@mkdir -p "$(@D)"
	xgettext --package-name=turris-diagnostics -d turris-diagnostics --no-location --language=Shell --output=$@ $^

define CASEDEF_LANG

# The touch in this rule is because msgmerge won't update file if there are no
# changes and thus won't settle build fully.
locale/$(1)/turris-diagnostics.po: locale/turris-diagnostics.pot
	msgmerge --backup off --update "$$@" "$$<"
	touch "$$@"

.PHONY: update-$(1)
update: update-$(1)
update-$(1): locale/$(1)/turris-diagnostics.po
	msgmerge --backup off --force-po --update "$(2)/$(1).po" "$$<"

.PHONY: install-$(1)
install: install-$(1)
install-$(1): locale/$(1)/turris-diagnostics.mo
	install -D $$< $$(DESTDIR)/usr/share/locale/$(1)/LC_MESSAGES/turris-diagnostics.mo

endef
$(foreach LANG, $(LANGS), $(eval $(call CASEDEF_LANG,$(LANG))))
