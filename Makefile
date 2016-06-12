%.html: %.md Makefile
	pandoc -c nbn-devops.css -s -f markdown -t html --standalone --self-contained -o $@ $<

%.odt: %.md Makefile
	pandoc --standalone -f markdown -t odt -o $@ $<

%.pdf: %.md Makefile
	markdown2pdf -f markdown -o $@ $<

all: doc.html doc.odt doc.pdf
