<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:db = "http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="exsl db"
                version="1.0">
  <xsl:output method="text" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:variable name="version" select="'0.1'"/>


  <xsl:template name="makestring">
    <xsl:param name="c" />
    <xsl:param name="n" />
    <xsl:if test="$n &gt; 0">
      <xsl:value-of select="$c" />
      <xsl:call-template name="makestring">
        <xsl:with-param name="c" select="$c" />
        <xsl:with-param name="n" select="$n - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

 <xsl:template name="maketitle">
   <xsl:param name="s" />
   <xsl:variable name="ns" select="normalize-space($s)" />
   <xsl:variable name="sz" select="string-length($ns)" />
   <xsl:text>&#10;&#10;</xsl:text>
   <xsl:value-of select="$ns" />
   <xsl:call-template name="makestring">
     <xsl:with-param name="c" select="'_'" />
     <xsl:with-param name="n" select="80 - $sz" />
   </xsl:call-template>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>&#10;&#10;</xsl:text>
 </xsl:template>

  <xsl:template match="db:section" mode="tr">
    <xsl:apply-templates select="*|text()" mode="tr"/>
  </xsl:template>
  

  <xsl:template name="footnotes">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="s">
        FOOTNOTES
      </xsl:with-param>
    </xsl:call-template>
    <xsl:variable name="footnotessofar">
        <xsl:value-of select="count(preceding-sibling::*//db:footnote)" />
    </xsl:variable>
    <xsl:for-each select=".//db:footnote">
      <xsl:number value="position() + $footnotessofar" format="[1] " />
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="db:title" mode="tr" >
    <xsl:call-template name="maketitle">
      <xsl:with-param name="s">
        <xsl:apply-templates select="*|text()" mode="tr"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="db:para|db:simpara" mode="tr">
    <xsl:apply-templates select="*|text()" mode="tr" />
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="position() &lt; last()" >
      <xsl:text>&#10;  </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="db:inlinemediaobject" mode="tr" />

  <xsl:template match="db:footnote" mode="tr">
    <xsl:text>(footnote</xsl:text>
    <xsl:number level="any" format=" [1])"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="tr">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="db:informaltable" mode="tr">
    <xsl:choose>
      <xsl:when test="@role='imagecontainer'">
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*|text()" mode="tr"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="db:informaltable//db:row" mode="tr">
    <xsl:variable name="c1">
      <xsl:value-of select="normalize-space(db:entry[1])"/>
    </xsl:variable>
    <xsl:variable name="s1">
      <xsl:value-of select="16 - string-length($c1)" />
    </xsl:variable>
    <xsl:text>  </xsl:text>
    <xsl:value-of select="$c1" />
    <xsl:text> </xsl:text>
    <xsl:call-template name="makestring">
      <xsl:with-param name="c" select="' '" />
      <xsl:with-param name="n" select="$s1" />
    </xsl:call-template>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="normalize-space(db:entry[2])"/>
    <xsl:if test="position() &lt; last()" >
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/">
    <xsl:comment>
      <xsl:text>Rendered as Text using </xsl:text>
      <xsl:value-of select="$version"/>
      <xsl:text> </xsl:text>
    </xsl:comment>

    <xsl:variable name="title">
      <xsl:value-of select="/*/db:info/db:title" />
    </xsl:variable>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="makestring">
      <xsl:with-param name="c" select="' '" />
      <xsl:with-param name="n" select="80 - string-length($title)" />
    </xsl:call-template>
    <xsl:value-of select="$title" />
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    
    <xsl:call-template name="maketitle">
      <xsl:with-param name="s">
        TABLE OF CONTENTS
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="/*/db:section/db:title" mode="toc"/>

    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="/*/db:section" mode="tr"/>

    <!-- footnotes -->
    <xsl:call-template name="footnotes" />
  </xsl:template>
  
  <xsl:template match="db:title" mode="toc">
    <xsl:text>  </xsl:text>
    <xsl:apply-templates select="node()" mode="toc"/>
    <xsl:if test="position() &lt; last()" >
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text()" mode="toc">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  <xsl:template match="db:footnote" mode="toc">
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>