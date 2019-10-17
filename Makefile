.PHONY: all clean messages install

all:
	@echo usage:
	@echo "  make messages"
	@echo "  make install"
	@echo "  make clean"

clean:
	rm -rf locale/*/LC_MESSAGES/turris-diagnostics.mo
	rm -rf locale/*/LC_MESSAGES/turris-diagnostics.po~

LANGS:=$(shell ls -1 locale | grep -v diagnostics.pot)
INSTALL_TARGET:=/usr/share

# make messages
#
locale/turris-diagnostics.pot: diagnostics.sh modules/*.module
	mkdir -p locale/
	cat diagnostics.sh $^ | xgettext --package-name=turris-diagnostics -d turris-diagnostics --no-location --language=Shell --output=$@ -

define UPDATE_TRANSLATION

locale/$(1)/LC_MESSAGES/turris-diagnostics.po: locale/turris-diagnostics.pot
	if [ -e "$$@" ] ; then msgmerge --update --lang=$(1) --no-location $$@ $$< ; else msginit -i $$< -l $(1) --no-translator -o $$@ ; fi

endef

$(foreach LANG, $(LANGS), $(eval $(call UPDATE_TRANSLATION,$(LANG))))

messages: $(foreach LANG, $(LANGS), locale/$(LANG)/LC_MESSAGES/turris-diagnostics.po)

# make install
#
define COMPILE_MESSAGES

locale/$(1)/LC_MESSAGES/turris-diagnostics.mo: locale/$(1)/LC_MESSAGES/turris-diagnostics.po
	msgfmt -o $$@ $$<

endef

$(foreach LANG, $(LANGS), $(eval $(call COMPILE_MESSAGES,$(LANG))))

install: $(foreach LANG, $(LANGS), locale/$(LANG)/LC_MESSAGES/turris-diagnostics.mo)
	$(foreach mo_file,$^,install -D $(mo_file) $(INSTALL_TARGET)/$(mo_file))
