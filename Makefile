MAKEFLAGS += --no-builtin-rules

.PHONY: all
all:
	@

.PHONY: clean
clean:
	@

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


# $(1): translation name
# $(2): files translations should be extracted from
define TRANSLATION

$(1)_PO := $$(shell find locale -name $(1).po)
$(1)_MO := $$(patsubst %.po,%.mo,$$($(1)_PO))
$(1)_LANGS := $$(shell find locale -name $(1).po | cut -d '/' -f 2)

.PHONY: $(1) install-$(1) update-$(1)

.PHONY: extract-$(1)
extract: extract-$(1)
extract-$(1): locale/$(1).pot
locale/$(1).pot: $(2)
	@mkdir -p "$$(@D)"
	xgettext --package-name=$(1) -d $(1) --language=Shell --output=$$@ $$^

.PHONY: update-$(1)
update: update-$(1)
update-$(1): $$($(1)_PO)
# The touch in this rule is because msgmerge won't update file if there are no
# changes and thus won't settle build fully. We need to update modification
# time.
$$($(1)_PO): %.po: locale/$(1).pot
	msgmerge --backup off --update "$$@" "$$<"
	touch "$$@"

.PHONY: $(1)
all: $(1)
$(1): $$($(1)_MO)
$$($(1)_MO): %.mo: %.po
	msgfmt --output-file=$$@ $$<

.PHONY: install-$(1)
install: install-$(1)
install-$(1):
	@
$$(foreach LANG,$$($(1)_LANGS),$$(eval $$(call TRANSLATION_INSTALL,$(1),$$(LANG))))

clean: clean-$(1)
clean-$(1):
	rm -f $$($(1)_MO)

endef

# $(1): translation name
# $(2): translation language
define TRANSLATION_INSTALL

.PHONY: install-$(1)-$(2)
install-$(1): install-$(1)-$(2)
install-$(1)-$(2): locale/$(2)/$(1).mo
	install -D $$< $$(DESTDIR)/usr/share/locale/$(2)/LC_MESSAGES/$(1).mo

endef

$(eval $(call TRANSLATION,turris-diagnostics,diagnostics.sh $(wildcard modules/%.module)))
$(eval $(call TRANSLATION,turris-diagnostics-web,web/diagnostics.sh))
$(eval $(call TRANSLATION,turris-snapshots-web,web/snapshots.sh))
