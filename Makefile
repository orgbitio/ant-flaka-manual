
#
# V E R S I O N
#
# This is the manual's version 
VERSION_DOC=1.2.3

# This is the ant-flaka version documented by this manual
# Hint: Currently not used, instead change texmf/ant-flaka.cls!!
VERSION_AF=1.2

BASENAME=ant-flaka-$(VERSION_DOC)

all: target target/ant-flaka.db4 target/ant-flaka.pdf target/ant-flaka.tex target/ant-flaka.html target/$(BASENAME).db4 target/$(BASENAME).pdf target/$(BASENAME).html 

target:
	mkdir target

target/ant-flaka.pdf : target/ant-flaka.tex
	xelatex --output-directory="$(dir $@)" "\\def\\flakaversion{$(VERSION_AF)}\\input{$<}" && xelatex --output-directory="$(dir $@)" "\\def\\flakaversion{$(VERSION_AF)}\\input{$<}"

target/ant-flaka.db4 : ant-flaka.ad
	$(ASCIIDOC.cmd)

target/ant-flaka.tex : target/ant-flaka.db4
	$(DBLATEX.cmd) --type=tex -o $@ $<

target/ant-flaka.html : ant-flaka.ad
	asciidoc -v -n -b xhtml11 -a stylesdir=$$(pwd) -o $@ $<

target/$(BASENAME).html : target/ant-flaka.html
	cp $< $@

target/$(BASENAME).pdf : target/ant-flaka.pdf
	cp $< $@

target/$(BASENAME).ad : target/ant-flaka.ad
	cp $< $@

target/$(BASENAME).db4 : target/ant-flaka.db4
	cp $< $@

#
# Trigger
#

target/ant-flaka.html: Makefile 
target/ant-flaka.pdf : Makefile texmf/ant-flaka.cls texmf/ant-flaka.sty ant-flaka.specs
target/ant-flaka.db4 : \
 	Makefile \
 	xsl/ant-flaka.xsl \
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

DBLATEX.cmd  = dblatex --verbose -S ant-flaka.specs -o $@
ASCIIDOC.cmd = asciidoc -b docbook -o $@ $<
SAX.cmd      = java -jar ~/saxon/saxon9he.jar
XSLT.cmd     = xsltproc --nonet --novalid
XMLLINT.cmd  = xmllint --encode utf-8 --format 

clean:
	rm -rf *.aux *.log *.toc *.cb *.db* *.out ant-flaka.{html,pdf,tex} target
