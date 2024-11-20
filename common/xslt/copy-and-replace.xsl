<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                exclude-result-prefixes="tei xi"
                version="3.0">

    <!-- Identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Replace <tagsDecl> with <xi:include> -->
    <xsl:template match="tei:tagsDecl">
	<xi:include href="includes/tagsDecl.xml"/>
    </xsl:template>

</xsl:stylesheet>
