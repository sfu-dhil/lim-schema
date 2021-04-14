<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.oxygenxml.com/ns/extension"
    xmlns:xt="http://www.oxygenxml.com/ns/extension"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="https://www.oxygenxml.com/ns/doc/xsl"
    version="3.0">
    <xd:doc>
        <xd:desc>
            <xd:p>Stylesheet to create the framework distribution for the Lyon in Mourning project.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="pd" select="'../'" as="xs:string"/>
    <xsl:param name="repoOwner">joeytakeda</xsl:param>
    <xsl:param name="repoName">lim-schema</xsl:param>
    <xsl:param name="framework">lyon_in_mourning</xsl:param>
    <xsl:param name="env" select="'dev'"/>
    
    <xsl:output cdata-section-elements="xt:license"/>
    
    <!--Make the version something totally unique each time this is in the dev context-->
    <xsl:variable name="version"
        select="unparsed-text($pd || 'VERSION')
        => normalize-space()
        => replace('\d+$',replace(string(current-dateTime()),'[^\d]',''))"
        as="xs:string"/>
    
    
    <xsl:variable name="ODD" select="document($pd || 'schema/lim.odd')" as="document-node()"/> 
    
    <!--Identity transform-->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="xt:location">
        <xsl:copy>
            <xsl:attribute name="href">
                <xsl:value-of expand-text="yes">https://github.com/{$repoOwner}/{$repoName}/releases/latest/download/{$framework}.zip</xsl:value-of>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xt:version">
        <xsl:copy>
            <xsl:value-of select="$version"/>
        </xsl:copy>
        <xsl:result-document href="{$pd}/dist/VERSION" method="text">
            <xsl:sequence select="$version"/>
        </xsl:result-document>
        
    </xsl:template>
    
    
    <xsl:template match="comment()"/>
    
    
  
    
    
</xsl:stylesheet>