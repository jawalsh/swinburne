<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
>
    <!-- Identity template: copies all nodes and attributes -->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="/">
	    <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="map[not(@key)]" priority="99">
	    <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- Preserve text nodes -->
    <xsl:template match="text() | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
