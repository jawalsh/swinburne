<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    version="3.0">
    <xsl:import href="config.xsl"/>
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
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="generateURL">
								<xsl:with-param name="docID" select="fn:map[@key='work']/fn:string[@key='id']"/>
								<xsl:with-param name="parent-dir" select="'html'"/>
							</xsl:call-template>
						</xsl:attribute>

                                        <xsl:value-of select="fn:map[@key='work']/fn:string[@key='title']"/>
				</a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
		</xsl:when>
		<xsl:otherwise>
			<li>
				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="generateURL">

							<xsl:with-param name="docID" select="fn:map[@key='volume']/fn:string[@key='id']"/>
							<xsl:with-param name="parent-dir" select="'html'"/>
						</xsl:call-template>
					</xsl:attribute>
				<!-- Extract the volume title -->
				<xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/>
			</a>
			</li>
		</xsl:otherwise>
	</xsl:choose>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="generateURL">
	<xsl:param name="docID"/>
	<xsl:param name="parent-dir"/>
	<xsl:value-of select="concat('https://',$server,'/',$site-dir,'/',$parent-dir,'/',$docID,'.html')"/>
    </xsl:template>
</xsl:stylesheet>
