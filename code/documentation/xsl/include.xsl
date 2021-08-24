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
            <xd:p><xd:b>Created on:</xd:b> Jul 20, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Module for including bits from the schema; this needs to be 
            a separate module because it is used both in the documentation process
            and the schema building processing.</xd:p>
        </xd:desc>
        <xd:param name="verbose">A static parameter for switching on/off messaging.</xd:param>
    </xd:doc>
    
    <!--**************************************************************
       *                                                            * 
       *                         Parameters                         *
       *                                                            *
       **************************************************************-->
    
    <xsl:param name="verbose" static="yes" select="false()"/>
    
    <!--**************************************************************
       *                                                            * 
       *                           Modes                            *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Identity transform</xd:desc>
    </xd:doc>
    <xsl:mode name="include" on-no-match="shallow-copy"/>
        
    <!--**************************************************************
       *                                                            * 
       *                        Variables                           *
       *                                                            *
       **************************************************************-->

    <xd:doc>
        <xd:desc>The input document's URI</xd:desc>
    </xd:doc>
    <xsl:variable name="docUri" select="document-uri(/)" as="xs:anyURI"/>
    
    <!--**************************************************************
       *                                                            * 
       *                       Root template                        *
       *                                                            *
       **************************************************************--> 
    
    <xd:doc>
        <xd:desc>Root template with lower priority as it conflicts if included elsewhere.</xd:desc>
    </xd:doc>
    <xsl:template match="/" priority="0">
        <xsl:apply-templates mode="include"/>
    </xsl:template>
    
    <!--**************************************************************
       *                                                            * 
       *                     Templates: #include                    *
       *                                                            *
       **************************************************************-->
    
    <xd:doc>
        <xd:desc>Resolve any of the includes</xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction('module')" mode="include">
        <xsl:variable name="rel" select="'modules/' || . || '.xml'" as="xs:string"/>
        <xsl:variable name="abs" select="resolve-uri($rel, $docUri)" as="xs:anyURI"/>
        <xsl:message select="'Fetching ' || $rel" use-when="$verbose"/>
        <xsl:try>
            <xsl:apply-templates 
                select="document($abs)//schemaSpec/*"
                mode="#current"/>  
            <xsl:catch>
                <xsl:message terminate="yes">ERROR: Cannot fetch <xsl:value-of select="$abs"/></xsl:message>
            </xsl:catch>
        </xsl:try>
    </xsl:template>
</xsl:stylesheet>