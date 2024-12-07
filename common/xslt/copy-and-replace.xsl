<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.tei-c.org/ns/1.0"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xi="http://www.w3.org/2001/XInclude"
		xmlns:cx="http://xmlcalabash.com/ns/extensions"
		xmlns:z="https://github.com/Conal-Tuohy/XProc-Z"
		xmlns:saxon="http://saxon.sf.net/"
		xmlns:c="http://www.w3.org/ns/xproc-step" 
		xmlns:chymistry="tag:conaltuohy.com,2018:chymistry"
                exclude-result-prefixes="tei xi saxon c chymistry fn cx z"
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


    <xsl:template match="tei:sourceDesc/tei:listBibl">
	<xi:include href="includes/meta-listBibl.xml"/>
    </xsl:template>


    <xsl:template match="tei:sourceDesc/tei:listEvent">
	<xi:include href="includes/meta-listEvent.xml"/>
    </xsl:template>


    <xsl:template match="tei:sourceDesc/tei:listOrg">
	<xi:include href="includes/meta-listOrg.xml"/>
    </xsl:template>


    <xsl:template match="tei:sourceDesc/tei:listPerson">
	<xi:include href="includes/meta-listPerson.xml"/>
    </xsl:template>


    <xsl:template match="tei:sourceDesc/tei:listPlace">
	<xi:include href="includes/meta-listPlace.xml"/>
    </xsl:template>

</xsl:stylesheet>
