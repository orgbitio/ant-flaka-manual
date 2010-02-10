

all: flaka.db4 flaka.pdf


flaka.pdf : flaka.db4
	$(DBLATEX.cmd) 

flaka.db4 : flaka.ad
	$(ASCIIDOC.cmd)

#
# Trigger
#


flaka.pdf : Makefile texmf/flaka.sty flaka.specs
flaka.db4 :  Makefile xsl/flaka.xsl

#
# Tools
#

DBLATEX.cmd  = dblatex -S flaka.specs -o $@ $<
ASCIIDOC.cmd = asciidoc -b docbook -o $@ $<
SAX.cmd      = java -jar ~/saxon/saxon9he.jar
XSLT.cmd     = xsltproc --nonet --novalid
XMLLINT.cmd  = xmllint --encode utf-8 --format 