<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    version="3.0">

    <xsl:output method="html" indent="yes"/>

    <!-- Initial Template -->
    <xsl:template name="xsl:initial-template">
        <html>
            <head>
                <title>Volume and Work Titles</title>
            </head>
            <body>
                <h1>Volume and Work Titles</h1>
                <ul>
                    <!-- Convert JSON to XML -->
                    <xsl:variable name="json-xml" select="fn:json-to-xml(fn:unparsed-text('../../contents.json'))"/>
                    
                    <!-- Iterate over the root array -->
                    <xsl:for-each select="$json-xml/fn:array/fn:map">
			    <xsl:choose>
				    <xsl:when test="fn:map[@key='volume']/fn:array[@key='works']/fn:map">
                        <li>
                            <!-- Extract the volume title -->
                            <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/>
                            <ul>
                                <!-- Iterate over works if they exist -->
                                <xsl:for-each select="fn:map[@key='volume']/fn:array[@key='works']/fn:map">
                                    <li>
                                        <!-- Extract the work title -->
                                        <xsl:value-of select="fn:map[@key='work']/fn:string[@key='title']"/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
		</xsl:when>
		<xsl:otherwise>
			<li>
				<!-- Extract the volume title -->
				<xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/> <xsl:value-of select="': NO CHILD WORKS!'"/>
			</li>
		</xsl:otherwise>
	</xsl:choose>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
