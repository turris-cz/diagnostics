MAKEFLAGS += --no-builtin-rules

MO:=$(patsubst %.po,%.mo,$(shell find -name turris-diagnostics.po -name turris-diagnostics-web.po -name turris-snapshots-web.po))

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

locale/turris-diagnostics-web.pot: web/diagnostics.sh
	@mkdir -p "$(@D)"
	xgettext --package-name=turris-diagnostics-web -d turris-diagnostics-web --no-location --language=Shell --output=$@ $^

locale/turris-snapshots-web.pot: web/snapshots.sh
	@mkdir -p "$(@D)"
	xgettext --package-name=turris-snapshots-web -d turris-snapshots-web --no-location --language=Shell --output=$@ $^


define CASEDEF_LANG

# The touch in this rule is because msgmerge won't update file if there are no
# changes and thus won't settle build fully.
locale/$(1)/$(2).po: locale/$(2).pot
	msgmerge --backup off --update "$$@" "$$<"
	touch "$$@"

.PHONY: update-$(1) update-$(2) update-$(2)-$(1)
update: update-$(1)
update-$(1): update-$(2)-$(1)
update-$(2): update-$(2)-$(1)
update-$(2)-$(1): locale/$(1)/$(2).po
	msgmerge --backup off --force-po --update "locale/$(1)/$(2).po" "$$<"

.PHONY: install-$(1) install-$(2) install-$(2)-$(1)
install: install-$(1)
install-$(1): install-$(2)-$(1)
install-$(2): install-$(2)-$(1)
install-$(2)-$(1): locale/$(1)/$(2).mo
	install -D $$< $$(DESTDIR)/usr/share/locale/$(1)/LC_MESSAGES/$(2).mo

endef

define CASEDEF_CATALOG
$(1)_LANGS:=$$(shell find locale -name $(1).po | cut -d '/' -f 2)
$$(foreach LANG, $$($(1)_LANGS), $$(eval $$(call CASEDEF_LANG,$$(LANG),$(1))))
endef

$(eval $(call CASEDEF_CATALOG,turris-diagnostics))
$(eval $(call CASEDEF_CATALOG,turris-diagnostics-web))
$(eval $(call CASEDEF_CATALOG,turris-snapshots-web))
