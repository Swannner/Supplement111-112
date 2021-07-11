#######################
# DO NOT EDIT THIS FILE
#######################

#   1) Make a copy of Makefile.paths.original
#      as Makefile.paths, which git will ignore.
#   2) Edit Makefile.paths to provide full paths to the root folders
#      of your local clones of the project repository and the mathbook
#      repository as described below.
#   3) The files Makefile and Makefile.paths.original
#      are managed by git revision control and any edits you make to
#      these will conflict. You should only be editing Makefile.paths.

##############
# Introduction
##############

# This is not a "true" makefile, since it does not
# operate on dependencies.  It is more of a shell
# script, sharing common configurations

######################
# System Prerequisites
######################

#   install         (system tool to make directories)
#   xsltproc        (xml/xsl text processor)
#   xmllint         (only to check source against DTD)
#   <helpers>       (PDF viewer, web browser, pager, Sage executable, etc)

#####
# Use
#####

#	A) Navigate to the location of this file
#	B) At command line:  make <some-target-from-the-options-below>

# The included file contains customized versions
# of locations of the principal components of this
# project and names of various helper executables
include Makefile.paths

###################################
# These paths are subdirectories of
# the project distribution
###################################
SRC       = $(PRJ)/ptx
IMGSRC    = $(PRJ)/external-images
OUTPUT    = $(PRJ)/output
PUB       = $(PRJ)/publication

# The project's root file
MAINFILE  = $(SRC)/supplement.ptx

# The project's styling files
PUBFILE   = $(PUB)/publication.xml

# These paths are subdirectories of
# the PreTeXt distribution
PTXXSL = $(PTX)/xsl

# These paths are subdirectories of the output
# folder for different output formats
PRINTOUT   = $(OUTPUT)/print
HTMLOUT    = $(OUTPUT)/html
IMGOUT     = $(OUTPUT)/images

html:
	install -d $(OUTPUT)
	-rm -r $(HTMLOUT) || :
	install -d $(HTMLOUT)
	install -d $(HTMLOUT)/images
	install -d $(IMGOUT)
	install -d $(IMGSRC)
	cp -a $(IMGOUT) $(HTMLOUT) || :
	cp -a $(IMGSRC) $(HTMLOUT) || :
	cd $(HTMLOUT); \
	xsltproc --xinclude --stringparam watermark.text "DRAFT" --stringparam publisher $(PUBFILE)  $(PTXXSL)/pretext-html.xsl $(MAINFILE); \

images:
	install -d $(OUTPUT)
	-rm $(IMGOUT) || :
	install -d $(IMGOUT)
	$(PTX)/pretext/pretext -c latex-image -p $(PUBFILE) -f all -d $(IMGOUT) $(MAINFILE)

pdf:
	install -d $(OUTPUT)
	-rm -r $(PRINTOUT) || :
	install -d $(PRINTOUT)
	install -d $(PRINTOUT)/images
	install -d $(IMGOUT)
	install -d $(IMGSRC)
	cp -a $(IMGSRC) $(PRINTOUT) || :
	cd $(PRINTOUT); \
	xsltproc -xinclude --stringparam publisher $(PUBFILE) --stringparam latex.print 'yes' $(PTXXSL)/pretext-latex.xsl $(MAINFILE) > supplement111-112.tex; \
	xelatex supplement111-112.tex; \
	xelatex supplement111-112.tex; \


###########
# Utilities
###########

check:
	install -d $(OUTPUT)
	-rm $(OUTPUT)/jingreport.txt
	-java -classpath ~/jing-trang/build -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration -jar ~/jing-trang/build/jing.jar $(PTX)/schema/pretext.rng $(MAINFILE) > $(OUTPUT)/jingreport.txt
	less $(OUTPUT)/jingreport.txt
