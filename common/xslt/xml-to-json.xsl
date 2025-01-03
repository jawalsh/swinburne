<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                exclude-result-prefixes="xs fn">
    <xsl:output method="text" encoding="UTF-8" />

    <!-- Main Template -->
    <xsl:template match="/">
        <!-- Apply the xml-to-json function to the root element -->
        <xsl:value-of select="xml-to-json(/, map {
            'indent': true()
        })"/>
    </xsl:template>
</xsl:stylesheet>
