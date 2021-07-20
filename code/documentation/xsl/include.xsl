<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 20, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:mode name="include" on-no-match="shallow-copy"/>
    
    <xsl:variable name="docUri" select="document-uri(/)"/>
    
    <xsl:template match="/">
        <xsl:apply-templates mode="include"/>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Resolve any of the includes</xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction('module')" mode="include">
        <xsl:variable name="rel" select="'modules/' || . || '.xml'"/>
        <xsl:variable name="abs" select="resolve-uri($rel, $docUri)"/>
        <xsl:message select="'Fetching ' || $rel"/>
        <xsl:apply-templates 
            select="document($abs)//schemaSpec/*"
            mode="#current"/>  
    </xsl:template>
    
</xsl:stylesheet>