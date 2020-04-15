TEST = ./test.sh > $@
DEDUPE = \
	{ type sha256 >/dev/null 2>&1; } || alias sha256='sha256sum'; \
	set -- "`sha256 $@` | grep -Eo '\S{40}'"; \
	set -- "`sha256 $^` | grep -Eo '\S{40}'" "$$1"; \
	if [ "$$1" = "$$2" ]; then ln -sf $^ $@; fi

all: groff mandoc

groff: \
	groff-utf8.tsv \
	groff-ascii.tsv \

groff-c: \
	groff-utf8-c.tsv \
	groff-ascii-c.tsv

mandoc: \
	mandoc-utf8.tsv \
	mandoc-ascii.tsv


groff-utf8.tsv:;     $(TEST) groff -Tutf8
groff-ascii.tsv:;    $(TEST) groff -Tascii
mandoc-utf8.tsv:;    $(TEST) mandoc -Werror -Tutf8
mandoc-ascii.tsv:;   $(TEST) mandoc -Werror -Tascii

groff-utf8-c.tsv:  groff-utf8.tsv;  $(TEST) groff -Tutf8  -C; $(DEDUPE)
groff-ascii-c.tsv: groff-ascii.tsv; $(TEST) groff -Tascii -C; $(DEDUPE)

clean:
	rm -f *.tsv

.PHONY: clean
