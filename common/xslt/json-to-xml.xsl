<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:json="http://www.w3.org/2005/xpath-functions/json">

    <!-- Match the root element -->
    <xsl:template match="/">
	<xsl:variable name="json-input" select="unparsed-text('../data/contents.json')" />
        <xsl:variable name="parsed-json" select="json-to-xml($json-input)" as="document-node()" />

        <!-- Output the converted XML -->
        <xsl:copy-of select="$parsed-json"/>
    </xsl:template>

</xsl:stylesheet>
