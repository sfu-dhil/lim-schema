<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 18, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Transformation retrieving, including, and cleaning up
                documentation converted from Markdown to TEI in Pandoc into the
                ODD.</xd:p>
        </xd:desc>
        <xd:param name="verbose">Inherited from <xd:a href="include.xsl">include.xsl</xd:a>.</xd:param>
        <xd:param name="docsDir">Input directory where the produced TEI files live.</xd:param>
    </xd:doc>
    
    <!--**************************************************************
       *                                                            * 
       *                        Includes                            *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>We include the inclusion XSL for adding in the PI inclusions.</xd:desc>
    </xd:doc>
    <xsl:include href="include.xsl"/>
  
   
    <!--**************************************************************
       *                                                            * 
       *                        Params                              *
       *                                                            *
       **************************************************************-->
    
    <xsl:param name="docsDir" as="xs:string?"/>
    
    
    <!--**************************************************************
       *                                                            * 
       *                        Variables                           *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Stash the examples namespace for later use.</xd:desc>
    </xd:doc>
    <xsl:variable name="egNS">http://www.tei-c.org/ns/Examples</xsl:variable>
    
    <xd:doc>
        <xd:desc>The context</xd:desc>
    </xd:doc>
    <xsl:variable name="odd" select="/" as="document-node()"/>
    
    
    <!--**************************************************************
       *                                                            * 
       *                            Modes                           *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Modes for the transformation (most identity, some not).</xd:desc>
    </xd:doc>
    <xsl:mode name="pandoc" on-no-match="shallow-copy" exclude-result-prefixes="#all"/>
    <xsl:mode name="odd" on-no-match="shallow-copy"/>
    <xsl:mode name="index" on-no-match="shallow-skip"/>
    
    
    <!--**************************************************************
       *                                                            * 
       *                        Root template                       *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Set up the main transformation (with higher priority)</xd:desc>
    </xd:doc>
    <xsl:template match="/" priority="1">
        <xsl:apply-templates mode="odd"/>
    </xsl:template>
    
    <!--**************************************************************
       *                                                            * 
       *                       Templates: #odd                      *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Annoyingly, we have to wrap the index divGen in a div for it to valid,
        but we don't want that there in the mean time.</xd:desc>
    </xd:doc>
    <xsl:template match="div[divGen[@xml:id='index']]" mode="odd">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Any module for inclusion needs to be processed using
        the include mode in the include transform.</xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction('module')" mode="odd">
        <xsl:apply-templates select="." mode="include"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Template to retrieve the TEI'd markdown index, which serves as the TOC
            for the documentation, specifying the order of inclusion for the documents. That
            list is processed by the #index templates.
        </xd:desc>
    </xd:doc>
    <xsl:template match="divGen[@xml:id='index']" mode="odd">
        <xsl:variable name="indexDoc" select="dhil:getMarkdownDoc('index.md')" as="element()"/>
        <!--Since the lists could be nested, we want the outermost one-->
        <xsl:variable name="rootList" select="outermost($indexDoc//list)" as="element(list)"/>
        <xsl:apply-templates select="$rootList" mode="index"/>
    </xsl:template>
    
    <!--**************************************************************
       *                                                            * 
       *                        Templates: #index                   *
       *                                                            *
       **************************************************************-->
    
    <xsl:template match="item[p][list]" mode="index">
        <div>
            <head>
                <xsl:value-of select="p"/> 
            </head>
            <xsl:apply-templates select="list" mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Process a ref as a type of inclusion.</xd:desc>
    </xd:doc>
    <xsl:template match="ref[@target]" mode="index">
         <xsl:variable name="thisDoc" select="dhil:getMarkdownDoc(@target)" as="element()"/>
         <xsl:apply-templates select="$thisDoc" mode="pandoc">
             <xsl:with-param name="list" 
                 select="ancestor::item[1]/list" as="element(list)?"
                 tunnel="yes"/>
         </xsl:apply-templates>
    </xsl:template>
    
    
    <!--**************************************************************
       *                                                            * 
       *                        Templates: #pandoc                  *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Skip the body element of any pandoc file, since we're including it 
            in a new context; the pandoc templates mostly cleanup the weird
            TEI produced by pandoc.</xd:desc>
    </xd:doc>
    <xsl:template match="body" mode="pandoc">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Use the first div as the one to include within the expanded ODD.</xd:desc>
        <xd:param name="list">A tunnelled parameter of any sublist that ought to be included
        within this chapter.</xd:param>
    </xd:doc>
    <xsl:template match="body/div[1]" mode="pandoc">
        <xsl:param name="list" tunnel="yes" as="element(list)?"/>
        <xsl:copy>
            <!--Preserve space within examples esp.-->
            <xsl:attribute name="xml:space">preserve</xsl:attribute>
            <xsl:apply-templates select="@*|node()" mode="#current">
                <xsl:with-param name="rootId" tunnel="yes" select="tokenize(document-uri(root(.)),'[/\.]')[last() - 1]"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$list" mode="index"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Create the div's xml:id from its uri (taking the basename).</xd:desc>
    </xd:doc>
    <xsl:template match="body/div/@xml:id" mode="pandoc">
        <xsl:param name="rootId" tunnel="yes"/>
        <xsl:attribute name="xml:id" select="$rootId"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Every @xml:id afterwards should inherit the root
        to make sure everything is unique.</xd:desc>
    </xd:doc>
    <xsl:template match="div[not(parent::body)]/@xml:id" mode="pandoc">
        <xsl:param name="rootId" tunnel="yes"/>
        <xsl:attribute name="xml:id" select="$rootId || '_' || ."/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Remove the weird @type that pandoc produces.</xd:desc>
    </xd:doc>
    <xsl:template match="div/@type" mode="pandoc"/>
    
    
    <xd:doc>
        <xd:desc>Heads are more like descs in figures.</xd:desc>
    </xd:doc>
    <xsl:template match="figure/head" mode="pandoc">
        <figDesc>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </figDesc>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Any weird nested references should be unwrapped.</xd:desc>
    </xd:doc>
    <xsl:template match="ref[ref]" mode="pandoc">
        <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:template>
        
    <xd:doc>
        <xd:desc>Label cells shouldn't have a block-level paragraph.</xd:desc>
    </xd:doc>
    <xsl:template match="row[@role='label']/cell/p" mode="pandoc">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Code comes in different flavours, which is all back-ticked in markdown
        but we can be more specific in TEI. This template takes a set of
        regular expressions and attempts to determine what kind of code it is (an element,
        an attribute, an attribute value, or something else) and tags it appropriately if
        possible.</xd:desc>
    </xd:doc>
    <xsl:template match="seg[@type='code']" mode="pandoc">
        <xsl:variable name="string" select="string(.)" as="xs:string"/>
        <!--Each kind of code element can be determined by a RegEx;
            we stash these as key-val pairs so we can iterate through them-->
        <xsl:variable name="rexes" select="
            map{
                'gi': '^&lt;(.+)&gt;$',
                'att': '^@(.+)$',
                'val': '^&quot;(.+)&quot;$'
            }"
            as="map(xs:string, xs:string)"/>
        <xsl:iterate select="map:keys($rexes)">
            <!--If the iteration ever completes, then none of the more specific
                code matches were satisfied (since break != completion),
                so we simply wrap the code-like stuff in the code element-->
            <xsl:on-completion>
                <code>
                    <xsl:value-of select="$string"/>
                </code>
            </xsl:on-completion>
            <!--The element name (i.e. the key to the map)-->
            <xsl:variable name="elName" select="." as="xs:string"/>
            <!--The regular expression keyed to that item-->
            <xsl:variable name="rex" select="$rexes($elName)" as="xs:string"/>
            <!--If there's a match, break the loop, wrap the text with 
                the appropriate element, and use the rex to replace any
                characters that will be output automatically (angle brackets, @, etc)-->
            <xsl:if test="matches($string, $rex)">
                <xsl:break>
                    <xsl:element name="{$elName}">
                        <xsl:value-of select="replace($string, $rex, '$1')"/>
                    </xsl:element>
                </xsl:break>
            </xsl:if>
        </xsl:iterate>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Codeblocks, which we presume are XML, are a bit more difficult, since we want to be able
        to treat these as XML codeblocks throughout the processing. This template takes the
        serialized representation of the XML code, attempts to parse it, and if it's parsable, then
        passes it through the templates. This is wrapped in an xsl:try/xsl:catch so that if the block
        is not parseable, the process doesn't fail.</xd:desc>
    </xd:doc>
    <xsl:template match="ab[contains-token(@type,'codeblock')]" mode="pandoc" exclude-result-prefixes="#all">
        <xsl:try>
            <xsl:variable name="frag"
                select="parse-xml-fragment(string(.))"
                as="document-node()"
                exclude-result-prefixes="#all"/>
            <xsl:element name="egXML" namespace="{$egNS}">
                <xsl:apply-templates select="$frag" mode="#current" exclude-result-prefixes="#all"/>
            </xsl:element>
            <xsl:catch>
                <xsl:message>UNABLE TO PARSE <xsl:value-of select="."/></xsl:message>
                <code rend="block">
                    <xsl:apply-templates mode="#current"/>
                </code>
            </xsl:catch>
        </xsl:try>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Template to add the example namespace to all descendant elements of the egXML
        so that we don't output empty namespaces.</xd:desc>
    </xd:doc>
    <xsl:template match="*[empty(namespace-uri()) or namespace-uri() = '']" mode="pandoc">
        <xsl:element name="{local-name()}" namespace="{$egNS}">
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:element>
    </xsl:template>    
    
    <!--**************************************************************
       *                                                            * 
       *                        Functions                           *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Takes a basename (without a path) for a MD file, fetches
        the TEI equivalent, and returns the element's body.</xd:desc>
        <xd:param name="basename">The file's basename (i.e. "how_to_do_stuff.md"; "tutorial.md")</xd:param>
        <xd:return>A tei:body element.</xd:return>
    </xd:doc>
    <xsl:function name="dhil:getMarkdownDoc" as="element(body)">
        <xsl:param name="basename" as="xs:string"/>
        <xsl:variable name="uri"
            select="$docsDir || '/' || replace(normalize-space($basename),'\.md$','.xml')"
            as="xs:string"/>
        <xsl:message use-when="$verbose">Processing <xsl:value-of select="$uri"/></xsl:message>
        <xsl:try>
            <xsl:sequence select="document($uri)//body"/>
            <xsl:catch>
                <xsl:message terminate="yes">ERROR: Cannot retrieve markdown document <xsl:value-of select="$uri"/></xsl:message>
            </xsl:catch>
        </xsl:try>
    </xsl:function>
</xsl:stylesheet>