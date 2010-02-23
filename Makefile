

all: flaka.db4 flaka.pdf


flaka.pdf : flaka.db4
	$(DBLATEX.cmd) 

flaka.db4 : flaka.ad
	$(ASCIIDOC.cmd)

#
# Trigger
#


flaka.pdf : Makefile texmf/flaka.sty flaka.specs
flaka.db4 : \
 	Makefile \
 	xsl/flaka.xsl \
 	sections/el.ad \
 	sections/glossary.ad \
 	sections/howto.ad \
 	sections/install.ad \
 	sections/introduction.ad \
 	sections/overview.ad \
 	sections/task_break.ad \
 	sections/task_choose.ad \
 	sections/task_continue.ad \
 	sections/task_echo.ad \
 	sections/task_fail.ad \
 	sections/task_for.ad \
 	sections/task_install-property-handler.ad \
 	sections/task_let.ad \
 	sections/task_list.ad \
 	sections/task_properties.ad \
 	sections/task_rescue.ad \
 	sections/task_switch.ad \
 	sections/task_throw.ad \
 	sections/task_trycatch.ad \
 	sections/task_unless.ad \
 	sections/task_unset.ad \
 	sections/task_when.ad \
 	sections/task_while.ad \
 	sections/todo.ad \
  sections/task_scandep.ad \
  sections/task_logo.ad \
	$(nil)

#
# Tools
#

DBLATEX.cmd  = dblatex -S flaka.specs -o $@ $<
ASCIIDOC.cmd = asciidoc -b docbook -o $@ $<
SAX.cmd      = java -jar ~/saxon/saxon9he.jar
XSLT.cmd     = xsltproc --nonet --novalid
XMLLINT.cmd  = xmllint --encode utf-8 --format 

