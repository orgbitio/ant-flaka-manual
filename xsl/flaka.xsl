<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version="1.0">
    <xsl:variable name="latex.use.hyperref">0</xsl:variable>
  <xsl:param name="doc.section.depth">5</xsl:param>
  <xsl:param name="toc.section.depth">5</xsl:param>
  <xsl:param name="doc.pdfcreator.show">1</xsl:param>
  <xsl:param name="doc.publisher.show">0</xsl:param>
  <xsl:param name="doc.collab.show">1</xsl:param>
  <xsl:param name="doc.alignment"/>
  <xsl:param name="doc.layout">coverpage toc</xsl:param>
  <xsl:param name="set.book.num">1</xsl:param>
  <xsl:param name="draft.mode">maybe</xsl:param>
  <xsl:param name="draft.watermark">1</xsl:param>
  
  
  <!-- 
       #################
       # Main template #
       ################# 
  -->
  
  <xsl:template match="book|article">
    <xsl:param name="layout" select="$doc.layout"/>

    <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>

    <xsl:variable name="lang">
      <xsl:call-template name="l10n.language">
        <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
        <xsl:with-param name="xref-context" select="true()"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Latex preamble -->
    <xsl:apply-templates select="." mode="preamble">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:apply-templates>

    <xsl:text>%&#10;</xsl:text>
    <xsl:text>% Let's rock!&#10;</xsl:text>
    <xsl:text>%&#10;</xsl:text>
    <xsl:text>\usepackage{layout}%&#10;</xsl:text>
    <xsl:text>\begin{document}&#10;</xsl:text>
    <xsl:text>\layout*&#10;</xsl:text>
    <!-- 
    <xsl:text>\preamble&#10;</xsl:text>
    -->
    <!-- ?? -->
    <xsl:call-template name="label.id"/>
    
    <!-- Render -->
    <xsl:apply-templates select="
                                 *[not(self::abstract or
                                 self::preface or
                                 self::dedication or
                                 self::colophon)]
                                 "/>
    
    <!-- Colophon -->
    <xsl:apply-templates select="colophon"/>
  
    <!-- End LaTex document -->
    <xsl:text>%&#10;</xsl:text>
    <xsl:text>% That's it folks!&#10;</xsl:text>
    <xsl:text>%&#10;</xsl:text>
    <xsl:text>\end{document}&#10;</xsl:text>
    
  </xsl:template>

  <xsl:template match="book|article" mode="wrapper">
    <xsl:apply-templates select=".">
      <xsl:with-param name="layout">
        <xsl:if test="contains($doc.layout, 'index ')">
          <xsl:text>index </xsl:text>
        </xsl:if>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="book|article" mode="preamble">
    <xsl:param name="lang"/>
    <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>

    <xsl:text>% -----------------------------------------  &#10;</xsl:text>
    <xsl:text>% AUTOGENERATED LATEX FILE FROM XML DOCBOOK  &#10;</xsl:text>
    <xsl:text>%    customized by wh@haefelinger.it         &#10;</xsl:text>
    <xsl:text>% -----------------------------------------  &#10;</xsl:text>

    <!-- Parameters to pass to python parser -->
    <xsl:call-template name="py.params.set"/>
    <xsl:text>\documentclass[]{article}&#10;</xsl:text>
    
    <!-- Load babel before the style (bug #babel/3875) -->
    <xsl:call-template name="babel.setup"/>
    
    <xsl:text>\usepackage{flaka}&#10;</xsl:text>
    
    <!-- Go ahead and transform document into LaTeX -->
    <!-- <xsl:apply-templates select="." mode="docinfo"/> -->

    <!-- Document title -->
    <xsl:variable name="title">
      <xsl:call-template name="normalize-scape">
        <xsl:with-param name="string">
          <xsl:choose>
            <xsl:when test="title">
              <xsl:value-of select="title"/>
            </xsl:when>
            <xsl:when test="$info">
              <xsl:value-of select="$info/title"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- Get the Authors -->
    <xsl:variable name="authors">
      <xsl:if test="$info">
        <xsl:choose>
          <xsl:when test="$info/authorgroup/author">
            <xsl:apply-templates select="$info/authorgroup"/>
          </xsl:when>
          <xsl:when test="$info/author">
            <xsl:call-template name="person.name.list">
              <xsl:with-param name="person.list" select="$info/author"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:text>%&#10;</xsl:text>
    <xsl:text>% Define title and author&#10;</xsl:text>
    <xsl:text>%&#10;</xsl:text>
    <xsl:text>\newcommand{\dbktitle}{</xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:text>\newcommand{\dbkauthors}{</xsl:text>
    <xsl:value-of select="$authors"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>
  


  <!-- ################
       # Set of books #
       ################ -->

  <!-- Only one book from the set is printed -->
  <xsl:template match="set">
    <xsl:message>
      <xsl:text>Warning: only print the book [</xsl:text>
      <xsl:value-of select="$set.book.num"/>
      <xsl:text>]</xsl:text>
    </xsl:message>
    <xsl:apply-templates select="//book[position()=$set.book.num]"/>
  </xsl:template>

  <!-- 
       ############################################
       # Elements for which nothing is generated. #
       ############################################
  -->
  <xsl:template match="set/setinfo"></xsl:template>
  <xsl:template match="set/title"></xsl:template>
  <xsl:template match="set/subtitle"></xsl:template>
  <xsl:template match="book/title"/>
  <xsl:template match="article/title"/>
  <xsl:template match="bookinfo"/>
  <xsl:template match="articleinfo"/>


</xsl:stylesheet>
