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

    <xsl:template match="tei:catRef[last()]">
	    <xsl:param name="parent">
		    <xsl:value-of select="//tei:biblStruct[tei:note[@corresp = '#original_collection']]/tei:monogr/tei:title"/>
	    </xsl:param>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
	<catRef xml:id="parent_vol">
		<xsl:attribute name="target">
			<xsl:choose>
<xsl:when test="$parent = 'Poems and Ballads, First Series'">
	<xsl:value-of select="'#pb1'"/>
</xsl:when>
<xsl:when test="$parent = 'Songs Before Sunrise'">
	<xsl:value-of select="'#sbs'"/>
</xsl:when>
<xsl:when test="$parent = 'Songs of Two Nations'">
	<xsl:value-of select="'#sotn'"/>
</xsl:when>
<xsl:when test="$parent = 'Poems and Ballads, Second Series'">
	<xsl:value-of select="'#pb2'"/>
</xsl:when>
<xsl:when test="$parent = 'Songs of the Springtides'">
	<xsl:value-of select="'#sos'"/>
</xsl:when>
<xsl:when test="$parent = 'Studies in Song'">
	<xsl:value-of select="'#sis'"/>
</xsl:when>
<xsl:when test="$parent = 'The Heptalogia or The Seven Against Sense: A Cap with Seven Bells'">
	<xsl:value-of select="'#hept'"/>
</xsl:when>
<xsl:when test="$parent = 'Tristram of Lyonesse and Other Poems'">
	<xsl:value-of select="'#tol'"/>
</xsl:when>
<xsl:when test="$parent = 'A Century of Roundels'">
	<xsl:value-of select="'#cor'"/>
</xsl:when>
<xsl:when test="$parent = 'A Midsummer Holiday and Other Poems'">
	<xsl:value-of select="'#mhop'"/>
</xsl:when>
<xsl:when test="$parent = 'Poems and Ballads, Third Series'">
	<xsl:value-of select="'#pb3'"/>
</xsl:when>
<xsl:when test="$parent = 'Astrophel and Other Poems'">
	<xsl:value-of select="'#aop'"/>
</xsl:when>
<xsl:when test="$parent = 'A Channel Passage and Other Poems'">
	<xsl:value-of select="'#cpop'"/>
</xsl:when>
<xsl:when test="$parent = 'Poems of Algernon Charles Swinburne'">
	<xsl:value-of select="'#poemsacs'"/>
</xsl:when>
<xsl:when test="$parent = 'The Algernon Charles Swinburne Project'">
	<xsl:value-of select="'#acsp'"/>
</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'#fix'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</catRef>
    </xsl:template>

    <!-- Replace <tagsDecl> with <xi:include> -->
    <xsl:template match="tei:tagsDecl">
	<xi:include href="includes/tagsDecl.xml"/>
    </xsl:template>






</xsl:stylesheet>
