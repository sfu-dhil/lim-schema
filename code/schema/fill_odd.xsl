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
            <xd:p><xd:b>Created on:</xd:b> Feb 19, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Transformation for adding taxonomy values to the ODD.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xd:doc>
        <xd:desc>Add values from the renditions</xd:desc>
    </xd:doc>
    <xsl:template match="classSpec[@ident='att.global.rendition']/attList/attDef[@ident='rendition']/valList">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:for-each select="//rendition[@xml:id]">
                <xsl:variable name="name" select="substring-after(@xml:id,'rnd_')" as="xs:string"/>
                <valItem ident="rnd:{$name}">
                    <desc><xsl:value-of select="$name"/></desc>
                    <gloss><xsl:value-of select="if (desc) then desc else $name"/></gloss>
                </valItem>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    
    
</xsl:stylesheet>