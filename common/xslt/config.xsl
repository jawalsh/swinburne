<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:swinburne="tag:biblicon.org,2024:swinburne" 
  xmlns="http://www.w3.org/1999/xhtml" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xpath-default-namespace="http://www.w3.org/1999/xhtml" exclude-result-prefixes="fn map"
  expand-text="true">
  <!-- embed the page in global navigation -->
  <xsl:param name="current-uri"/>
  <xsl:param name="google-api-key" select="'AIzaSyBgfj-W6-mYky-0UnIHhhE1yfRt7P85o5I'"/>
  <xsl:param name="numberFigures" as="xs:boolean" select="true()"/>

  <xsl:param name="server" select="''"/>
  <xsl:param name="context" select="''"/>

  <!-- normalize context to '' or 'swinburne' (no leading/trailing slashes) -->
  <xsl:variable name="context-norm" as="xs:string"
    select="replace(replace(normalize-space($context), '^/+', ''), '/+$', '')"/>

  <!-- site-path: prefix a site-relative path with context (NO leading slash) -->
  <xsl:function name="swinburne:site-path" as="xs:string">
    <xsl:param name="p" as="xs:string"/>
    <xsl:variable name="p2" select="replace($p, '^/+', '')"/>
    <xsl:sequence select="
        if ($context-norm = '') then
          $p2
        else
          if ($p2 = '') then
            concat($context-norm, '/')
          else
            concat($context-norm, '/', $p2)
        "/>
  </xsl:function>

  <!-- absolute-url: https://server/{context}/{path} when server is set; else site-path -->
  <xsl:function name="swinburne:absolute-url" as="xs:string">
    <xsl:param name="p" as="xs:string"/>
    <xsl:sequence select="
        if (normalize-space($server) = '') then
          swinburne:site-path($p)
        else
          concat('https://', $server, '/', swinburne:site-path($p))
        "/>
  </xsl:function>
</xsl:stylesheet>
