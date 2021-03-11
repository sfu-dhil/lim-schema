<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jt="http://github.com/joeytakeda"
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:xd="https://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:param name="outDir"/>
    <xsl:param name="templateURI" select="'../assets/template.html'" as="xs:string"/>
    
    
    <xsl:include href="egXML.xsl"/>
    

    <!--We have to have output method='xhtml' and html-version='5.0' to produce
    validate XHTML5 -->
    <xsl:output method="xhtml" encoding="UTF-8" indent="yes" normalization-form="NFC"
        exclude-result-prefixes="#all" omit-xml-declaration="yes" html-version="5.0"/>
    
    
    <xsl:mode name="xh" on-no-match="shallow-copy"/>    
    
    <xsl:variable name="template" select="document($templateURI)" as="document-node()"/>
    
    <xsl:variable name="sourceDoc" select="TEI"/>
    <xsl:variable name="text" select="//text"/>
    <xsl:variable name="chapters" select="$text/body/div" as="element(div)+"/>
    <xsl:variable name="appendixItems" select="$text/back//div[@xml:id]/div[@xml:id]" as="element(div)+"/>
    <xsl:variable name="tocIds" select="for $div in ($chapters, $appendixItems) return jt:getId($div)" as="xs:string+"/>
    
    <xsl:variable name="toc" as="element(xh:ul)">
        <ul>
            <xsl:apply-templates select="$text/(body|back)" mode="toc"/>
        </ul>
    </xsl:variable>
    
    
    <xsl:template match="/">
 
        <xsl:call-template name="createDoc">
            <xsl:with-param name="id" select="'index'"/>
            <xsl:with-param name="root" select="$text/front"/>
        </xsl:call-template>
        
        <!--Create main chapters-->
        <xsl:for-each select="$chapters">
            <xsl:call-template name="createDoc">
                <xsl:with-param name="id" select="jt:getId(.)"/>
                <xsl:with-param name="root" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        
        <!--And create appendix chapters-->
        <xsl:for-each select="$appendixItems">
            <xsl:call-template name="createDoc">
                <xsl:with-param name="id" select="jt:getId(.)"/>
                <xsl:with-param name="root" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        
        
        
        
 <!--       
        
        <xsl:result-document href="{$outDir}/index.html">
            <xsl:apply-templates select="$template" mode="xh">
                <xsl:with-param name="thisDiv" tunnel="yes" select="$text/front"/>
                <xsl:with-param name="toc" tunnel="yes">
                    <xsl:apply-templates select="$text/(body|back)" mode="toc"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:result-document>-->

        
       <!-- <xsl:call-template name="createDoc">
            <xsl:with-param name="id" select="string(@xml:id)"/>
            <xsl:with-param name="root" select="$sourceDoc"/>
        </xsl:call-template>
        
        <xsl:result-document href="{$outDir}/full.html">
            
            <xsl:apply-templates select="$template" mode="xh">
                <xsl:with-param name="thisDiv" tunnel="yes" select="$sourceDoc"/>
                <xsl:with-param name="toc" tunnel="yes">
                    <xsl:apply-templates select="$text/(body|back)" mode="toc">
                        <xsl:with-param name="currDivId" tunnel="yes" select="'full'"/>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:result-document>-->
    </xsl:template>
    
    
    <xsl:template name="createDoc">
        <xsl:param name="id" as="xs:string"/>
        <xsl:param name="root" select="." as="element()"/>
        <xsl:message>Processing <xsl:value-of select="$id"/></xsl:message>
        <xsl:result-document href="{$outDir}/{$id}.html">
            <xsl:apply-templates select="$template" mode="xh">
                <xsl:with-param name="thisDiv" select="$root" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    
    <!--MAIN TEMPLATES-->
    
    <xsl:template match="teiHeader | back" mode="main"/>
    
    <xsl:template match="front | body | TEI | text" mode="main">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="p | div | ab | cit[quote] | cit/quote | list | item | list/label" mode="main">
        <div class="{local-name()}">
            <xsl:if test="self::div and head and not(@xml:id)">
                <xsl:attribute name="id" select="generate-id(.)"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="div/@type" mode="main">
        <xsl:attribute name="class" select="."/>
    </xsl:template>
    
    <xsl:template match="q | quote[not(ancestor::cit)] | title[not(@level)] | emph | label | gi | att | val | ident | label | term | foreign" mode="main">
        <span class="{local-name()} ">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="title[@level]" mode="main">
        <span class="title {@level}">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
  
    
    
    <xsl:template match="code[ancestor::head]" mode="main">
        <span class="code{if (@rend) then concat(' ', @rend) else ()}">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="code" mode="main">
        <pre>
            <xsl:if test="@rend">
                <xsl:attribute name="class" select="@rend"/>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </pre>
    </xsl:template>
    

    
    <xsl:template match="list[count(item) = 1 and item[list]]" mode="main">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="item[list][parent::list[count(item) = 1]]" mode="main">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="table" mode="main">
        <table>
            <xsl:apply-templates mode="#current"/>
        </table>
    </xsl:template>
    
    <xsl:template match="ref" mode="main">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:variable name="resolvedTarget" select="jt:resolveRef(@target,$thisDiv)"/>
        <xsl:variable name="classes" as="xs:string*">
            <xsl:if test="matches($resolvedTarget,concat('^',$thisDiv/@xml:id,'.html$'))">
                <xsl:value-of select="'selected'"/>
            </xsl:if>
            <xsl:if test="starts-with(@target,'#TEI.')">
                <xsl:value-of select="'spec'"/>
            </xsl:if>
        </xsl:variable>
        <a href="{jt:resolveRef(@target, $thisDiv)}">
             <xsl:if test="not(empty($classes))">
                 <xsl:attribute name="class" select="string-join($classes,' ')"/>
             </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>

    

    
    
    <xsl:template match="figure" mode="main">
        <figure>
            <xsl:apply-templates mode="#current"/>
        </figure>
    </xsl:template>
    <xsl:template match="graphic" mode="main">
        <img>
            <xsl:attribute name="alt" select="normalize-space(../figDesc)"/>
            <xsl:apply-templates select="@url|node()" mode="#current"/>
        </img>
    </xsl:template>
    
    <xsl:template match="figDesc" mode="main"/>
    
    
    <!--Repoint the src in graphics-->
    <xsl:template match="graphic/@url" mode="main">
        <xsl:attribute name="src" select="concat('graphics/',tokenize(.,'/')[last()])"/>
    </xsl:template>

    
    <xsl:template match="head" mode="main">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:variable name="count" select="count(ancestor::div[ancestor::div[. is $thisDiv]])"/>
        <xsl:element name="h{$count + 1}">
            <xsl:if test="@n">
                <xsl:attribute name="class" select="if (xs:integer(@n) gt 0) then 'error' else 'checked'"/>
            </xsl:if>
 
            <xsl:apply-templates select="@n|node()" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="head/@n" mode="main">
        <xsl:attribute name="data-n" select="."/>
    </xsl:template>
        
    <xsl:template match="row" mode="main">
        <tr>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell/@rend | table/@rend" mode="main"/>
    
    <xsl:template match="@role" mode="main">
        <xsl:attribute name='data-role' select="."/>
    </xsl:template>
    
    <xsl:template match="cell" mode="main">
        <td>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </td>
    </xsl:template>
    
    <xsl:template match="*" mode="main" priority="-1">
        <xsl:message>NOT MATCHING <xsl:value-of select="local-name(.)"/></xsl:message>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
 
    <xsl:template match="@cols" mode="main">
        <xsl:attribute name="colspan" select="."/>
    </xsl:template>
    
    <xsl:template match="eg:egXML" mode="main">
        <xsl:apply-templates select="." mode="tei"/>
    </xsl:template>
    

    
    <!--XH TEMPLATES-->
    <xsl:template match="xh:nav/xh:ul" mode="xh">
        <ul>
            <xsl:apply-templates select="$toc" mode="xh"/>
        </ul>
    </xsl:template>
    
    
    <xsl:template match="xh:a/@href" mode="xh">
        <xsl:param name="currDivId" tunnel="yes"/>
        <xsl:if test="not($currDivId = substring-before(.,'.html'))">
            <xsl:sequence select="."/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="xh:article" mode="xh">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*|h2" mode="#current"/>
            <xsl:apply-templates select="$thisDiv/node()" mode="main"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="xh:html/@id" mode="xh">
   
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:attribute name="id">
            <xsl:value-of select="
                if ($thisDiv/self::front) then 'index'
                else if ($thisDiv/self::TEI) then 'full'
                else $thisDiv/@xml:id"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="xh:head/xh:title" mode="xh">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:value-of select="$thisDiv/head[1]"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xh:article/xh:h2" mode="xh">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:copy>
            <xsl:value-of select="$thisDiv/head"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="xh:div[@id='appendix']" mode="xh">
        <xsl:param name="thisDiv" tunnel="yes"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:variable name="specLinks" select="$sourceDoc//ref[starts-with(@target,'#TEI.')]/@target/substring-after(.,'#')"/>
            <xsl:for-each select="distinct-values($specLinks)">
                <xsl:variable name="thisLink" select="."/>
                <div id="snippet_{.}">
                    <xsl:apply-templates select="$sourceDoc//div[@xml:id=$thisLink]/p[1]" mode="appendix"/>
                </div>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p" mode="appendix">
        <div class="p">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="*" priority="-1" mode="appendix">
        <xsl:apply-templates select="." mode="main"/>
    </xsl:template>
    
    <xsl:template match="ref" mode="appendix"/>
    
    <xsl:template match="p/text()" mode="appendix">
        <xsl:value-of select="replace(replace(.,'\[\s*$',''),'^\s*\]','')"/>
    </xsl:template>
    
    <!--TOC TEMPLATES-->
    
    <xsl:template match="div" mode="toc">
        <xsl:variable name="tokens"
            select="(jt:getId(.), ancestor-or-self::div[jt:getId(.) = $tocIds]/jt:getId(.))
                    => reverse()
                    => distinct-values()" as="xs:string+"/>
        <xsl:variable name="doc" select="$tokens[1]" as="xs:string"/>
        <xsl:variable name="ptr" select="$tokens[1] || '.html' || (if (count($tokens) = 2) then '#' || $tokens[2] else ())"/>
        <xsl:variable name="docExists" select="$tokens[1] = $tocIds" as="xs:boolean"/>
        <xsl:variable name="title" select="(head, jt:getId(.))[1] => string()"/>
        <li>
            <xsl:choose>
                <xsl:when test="$docExists">
                    <a href="{$ptr}"><xsl:value-of select="$title"/></a>
                </xsl:when>
                <xsl:otherwise>
                    <span><xsl:value-of select="$title"/></span>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:where-populated>
                <ul>
                    <xsl:apply-templates select="div" mode="#current"/>
                </ul>
            </xsl:where-populated>
        </li>
        
    </xsl:template>
    
    
  <!--  <xsl:template match="div" mode="toc">
        <xsl:param name="currDivId" tunnel="yes" as="xs:string"/>
        <xsl:variable name="this" select="." as="element(div)"/>
        <xsl:variable name="isMainItem" select="some $div in ($chapters, $appendixItems) satisfies ($div[. is $this])" as="xs:boolean"/>
        <xsl:variable name="head" select="(head | @xml:id)[1] => string()" as="xs:string"/>
        <xsl:variable name="id" select="jt:getId($this)" as="xs:string"/>
        <xsl:variable name="isCurrent" select="$id = $currDivId" as="xs:boolean"/>
        <li>
            <xsl:element name="{if ($isCurrent) then 'span' else 'a'}">
                <xsl:if test="not($isCurrent)">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$isMainItem"><xsl:value-of select="$id || '.html'"/></xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="jt:getId($this/ancestor::div[jt:getId(.) = (($chapters,$appendixItems)!jt:getId(.))][1]) || '#' || $id"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$head"/>
            </xsl:element>
            <xsl:where-populated>
                <ul>
                    <xsl:apply-templates mode="#current"/>
                </ul>
            </xsl:where-populated>
        </li>
    </xsl:template>-->
    
    <xsl:function name="jt:resolveRef">
        <xsl:param name="target"/>
        <xsl:param name="div"/>
        <xsl:choose>
            <xsl:when test="starts-with($target,'#')">
                <xsl:choose>
                    <xsl:when test="$div/descendant-or-self::tei:*[@xml:id=substring-after(@target,'#')]">
                        <xsl:value-of select="$target"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(substring-after($target,'#'),'.html')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$target"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="jt:getId" as="xs:string" new-each-time="no">
        <xsl:param name="thing" as="element()"/>
        <xsl:sequence 
            select="if ($thing/@xml:id) then $thing/@xml:id else generate-id($thing)"/>
    </xsl:function>
    
</xsl:stylesheet>