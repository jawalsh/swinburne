<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
version="3.0"
xmlns:fn="http://www.w3.org/2005/xpath-functions"
xpath-default-namespace="http://www.tei-c.org/ns/1.0">

<xsl:template match="/TEI"/>

<xsl:param name="input" select="'../../contents.json'"/>

<xsl:template name="xsl:initial-template">
<xsl:apply-templates select="json-doc($input)"/>
</xsl:template>

<xsl:template match="//map[@key='volume']">
	<xsl:value-of select="string[@key='title']"/>
</xsl:template>


</xsl:stylesheet>
