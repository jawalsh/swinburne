<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xhtml" indent="no"/>
   <xsl:template match="node() | @*">
       <xsl:copy>
           <xsl:apply-templates select="node() | @*"/>
       </xsl:copy>
   </xsl:template>
    
</xsl:stylesheet>
