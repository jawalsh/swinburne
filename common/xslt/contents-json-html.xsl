<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn" version="3.0">
  <xsl:import href="config.xsl"/>
  <xsl:output method="xhtml" indent="yes"/>
  <!-- Initial Template -->
  <xsl:template name="xsl:initial-template">
    <!-- Convert JSON to XML -->
    <xsl:variable name="json-xml" select="fn:json-to-xml(fn:unparsed-text('../data/contents.json'))"/>
    <xsl:variable name="contents-swinburne" select="$json-xml/fn:array/fn:map[not(fn:map/fn:string[@key='author'])]" />
    <xsl:variable name="contents-other" select="$json-xml/fn:array/fn:map[fn:map/fn:string[@key='author']]" />

    <html>
      <head>
        <title>Volume and Work Titles</title>
      </head>
      <body>
        <main role="main" class="flex-shrink-0 py-4">
          <div class="container">
            <div id="content" class="py2 w-75 mx-auto">
              <h1 class="h3">The Algernon Charles Swinburne Project: Contents</h1>
              <div>
                <h2 class="h4">Works by Swinburne</h2>
                <ul>
			<xsl:call-template name="process-contents-items">
				<xsl:with-param name="contents-items" select="$contents-swinburne"/>
			</xsl:call-template>
                </ul>
		</div>
		<div>
                <h2 class="h4">Secondary Works</h2>
                <ul>
			<xsl:call-template name="process-contents-items">
				<xsl:with-param name="contents-items" select="$contents-other"/>
			</xsl:call-template>
                </ul>
              </div>

            </div>
          </div>
        </main>
        <script src="js/openContents.js"/>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="process-contents-items">
    <xsl:param name="a-vol-class" select="'w-auto mb-2 h5 toggle-hover-line d-list-item'"/>
    <xsl:param name="a-nested-class" select="'link-underline-opacity-0 toggle-hover-line'"/>
    <xsl:param name="production" select="'yes'"/>

	  <xsl:param name="contents-items"/>
          <xsl:for-each select="$contents-items">
                    <xsl:sort select="fn:map/fn:string[@key='date']" data-type="text" order="ascending"/>
                    <!-- Extract the volume title -->
                    <xsl:variable name="volume-title">
                      <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/>
                    </xsl:variable>
                    <xsl:variable name="volume-date">
                      <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='date']"/>
                      <!--  <xsl:value-of select="concat(' (',fn:map[@key='volume']/fn:string[@key='date'],')')"/> -->
                    </xsl:variable>
                    <xsl:variable name="volume-author">
                      <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='author']"/>
                    </xsl:variable>
                    <xsl:variable name="volume-id">
                      <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='id']"/>
                    </xsl:variable>
                    <xsl:if test="$production = 'yes' and not($volume-id = 'internal')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="fn:map[@key='volume']/fn:array[@key='works']/fn:map">
                            <a class="{$a-vol-class}" data-bs-toggle="collapse" href="{concat('#',$volume-id,'-contents')}">
                              <xsl:value-of select="concat($volume-title,' (',$volume-date,')')"/>
                              <xsl:if test="not($volume-author = '')">
                                <br/>
                                <span class="h6">
                                  <xsl:value-of select="$volume-author"/>
                                </span>
                              </xsl:if>
                            </a>
                            <div class="collapse" id="{concat($volume-id,'-contents')}">
                              <div class="ms-2 mb-2 card card-body">
                                <ul>
                                  <xsl:if test="fn:map[@key='work']/fn:array[@key='contents']">
                                    <ul>
                                      <xsl:for-each select="fn:map[@key='work']/fn:array[@key='contents']/fn:map">
                                        <li>
                                          <!-- Extract the item title -->
                                          <a class="{$a-nested-class}">
                                            <xsl:attribute name="href">
                                              <xsl:call-template name="generateInternalURL">
                                                <xsl:with-param name="docID" select="ancestor::fn:map[@key = 'work']/fn:string[@key = 'id']"/>
                                                <xsl:with-param name="ref" select="fn:map[@key='item']/fn:string[@key='id']"/>
                                              </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:value-of select="fn:map[@key='item']/fn:string[@key='title']"/>
                                          </a>
                                        </li>
                                      </xsl:for-each>
                                    </ul>
                                  </xsl:if>
                                  <!-- Iterate over works if they exist -->
                                  <xsl:for-each select="fn:map[@key='volume']/fn:array[@key='works']/fn:map">
                                    <li>
                                      <!-- Extract the work title -->
                                      <a class="{$a-nested-class}">
                                        <xsl:attribute name="href">
                                          <xsl:call-template name="generateURL">
                                            <xsl:with-param name="docID" select="fn:map[@key='work']/fn:string[@key='id']"/>
                                          </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:value-of select="fn:map[@key='work']/fn:string[@key='title']"/>
                                      </a>
                                      <xsl:if test="fn:map[@key='work']/fn:array[@key='contents']">
                                        <ul>
                                          <xsl:for-each select="fn:map[@key='work']/fn:array[@key='contents']/fn:map">
                                            <li>
                                              <!-- Extract the item title -->
                                              <a class="{$a-nested-class}">
                                                <xsl:attribute name="href">
                                                  <xsl:call-template name="generateInternalURL">
                                                    <xsl:with-param name="docID" select="ancestor::fn:map[@key = 'work']/fn:string[@key = 'id']"/>
                                                    <xsl:with-param name="ref" select="fn:map[@key='item']/fn:string[@key='id']"/>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                                <xsl:value-of select="fn:map[@key='item']/fn:string[@key='title']"/>
                                              </a>
                                            </li>
                                          </xsl:for-each>
                                        </ul>
                                      </xsl:if>
                                    </li>
                                  </xsl:for-each>
                                </ul>
                              </div>
                            </div>
                          </xsl:when>
                          <xsl:when test="fn:map[@key='volume']/fn:array[@key='contents']/fn:map">
                            <a class="{$a-vol-class}" data-bs-toggle="collapse" href="{concat('#',$volume-id,'-contents')}">
                              <xsl:value-of select="concat($volume-title,' (',$volume-date,')')"/>
                              <xsl:if test="not($volume-author = '')">
                                <br/>
                                <span class="h6">
                                  <xsl:value-of select="$volume-author"/>
                                </span>
                              </xsl:if>
                            </a>
                            <!--
                          <xsl:attribute name="href">
                            <xsl:call-template name="generateURL">
                              <xsl:with-param name="docID" select="fn:map[@key='volume']/fn:string[@key='id']"/>
                            </xsl:call-template>
                          </xsl:attribute>
                      <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/>
	      </a>
                      <xsl:value-of select="concat(' (',fn:map[@key='volume']/fn:string[@key='date'],')')"/>
					    -->
                            <div class="collapse" id="{concat($volume-id,'-contents')}">
                              <div class="ms-2 mb-2 card card-body">
                                <ul>
                                  <!-- Iterate over contents if they exist -->
                                  <xsl:for-each select="fn:map[@key='volume']/fn:array[@key='contents']/fn:map">
                                    <li>
                                      <!-- Extract the item title -->
                                      <a class="{$a-nested-class}">
                                        <xsl:attribute name="href">
                                          <xsl:call-template name="generateInternalURL">
                                            <xsl:with-param name="docID" select="ancestor::fn:map[@key = 'volume']/fn:string[@key = 'id']"/>
                                            <xsl:with-param name="ref" select="fn:map[@key='item']/fn:string[@key='id']"/>
                                          </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:value-of select="fn:map[@key='item']/fn:string[@key='title']"/>
                                      </a>
                                    </li>
                                  </xsl:for-each>
                                </ul>
                              </div>
                            </div>
                          </xsl:when>
                          <xsl:otherwise>
                            <a class="{$a-vol-class}">
                              <xsl:attribute name="href">
                                <xsl:call-template name="generateURL">
                                  <xsl:with-param name="docID" select="fn:map[@key='volume']/fn:string[@key='id']"/>
                                </xsl:call-template>
                              </xsl:attribute>
                              <!-- Extract the volume title -->
                              <xsl:value-of select="concat($volume-title,' (',$volume-date,')')"/>
                              <xsl:if test="not($volume-author = '')">
                                <br/>
                                <span class="h6">
                                  <xsl:value-of select="$volume-author"/>
                                </span>
                              </xsl:if>
                            </a>
                          </xsl:otherwise>
                        </xsl:choose>
                      </div>
                    </xsl:if>
                  </xsl:for-each>


  </xsl:template>


  <xsl:template name="generateURL">
    <xsl:param name="docID"/>
    <xsl:choose>
	    <xsl:when test="$site-dir = ''">
    <xsl:value-of select="concat('https://',$server,'/',$docID,'.html')"/>
	    </xsl:when>
	    <xsl:otherwise>
    <xsl:value-of select="concat('https://',$server,'/',$site-dir,'/',$docID,'.html')"/>
    </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <xsl:template name="generateInternalURL">
    <xsl:param name="docID"/>
    <xsl:param name="ref"/>
    <xsl:choose>
	    <xsl:when test="$site-dir = ''">
    <xsl:value-of select="concat('https://',$server,'/',$docID,'.html#',$ref)"/>
	    </xsl:when>
	    <xsl:otherwise>
    <xsl:value-of select="concat('https://',$server,'/',$site-dir,'/',$docID,'.html#',$ref)"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
