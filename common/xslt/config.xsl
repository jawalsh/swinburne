<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xpath-default-namespace="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="fn map"
	 expand-text="true">
	<!-- embed the page in global navigation -->
	<xsl:param name="current-uri"/>
        <xsl:param name="google-api-key"/>
        <xsl:param name="server" select="'swinburne.luddy.indiana.edu'"/>
        <xsl:param name="site-dir" select="''"/>
</xsl:stylesheet>
