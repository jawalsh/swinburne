<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns="http://www.w3.org/1999/xhtml" xmlns:map="http://www.w3.org/2005/xpath-functions/map" version="3.0" xpath-default-namespace="http://www.w3.org/1999/xhtml" exclude-result-prefixes="fn map" expand-text="true">
  <xsl:output cdata-section-elements="script" indent="yes"/>
  <xsl:import href="config.xsl"/>
  <!-- embed the page in global navigation -->
  <xsl:param name="current-uri"/>
  <xsl:param name="context"/>
  <xsl:param name="html-doc-id" select="/html/@id"/>
  <xsl:param name="a-nested-class" select="'link-underline-opacity-0 toggle-hover-line'"/>
  <xsl:variable name="menus" select="json-to-xml(unparsed-text('../data/menus.json'))"/>
  <xsl:variable name="volume-id" select="/html/head/meta[@name = 'parent_vol']/@content"/>
  <xsl:variable name="contents-json-xml" select="fn:json-to-xml(fn:unparsed-text('../data/contents.json'))"/>
  <xsl:variable name="volume" select="$contents-json-xml//fn:map[@key = 'volume' and fn:string[@key = 'id'] = $volume-id]"/>
  <xsl:variable name="volume-title" select="$volume/fn:string[@key='title']"/>
  <xsl:mode on-no-match="shallow-copy"/>
  <!-- insert link to global CSS, any global <meta> elements belong here too -->
  <xsl:template match="head">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*"/>
      <!-- meta -->
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <meta name="description" content="The Algernon Charles Swinburne Project: A Scholarly Edition"/>
      <meta name="author" content="John A. Walsh"/>
      <xsl:call-template name="pagefind-meta"/>
      <!-- js -->
      <!-- link to customized bootstrap css -->
      <link rel="stylesheet" href="css/custom.min.css"/>
      <script defer="defer" src="https://umami.biblicon.org/script.js" data-website-id="a43c1768-6a95-4dd4-8f44-832a473a6945"></script>
    </xsl:copy>
  </xsl:template>
  <!-- add a global suffix to every page title -->
  <xsl:template match="title">
    <xsl:copy>
      <xsl:value-of select="concat('The Algernon Charles Swinburne Project: ',.)"/>
    </xsl:copy>
  </xsl:template>
  <!-- insert boiler plate into the body -->
  <xsl:template match="body">
    <xsl:copy>
	    <xsl:if test="/html/head/meta[@name = 'status']/@content = 'published'">
		    <xsl:attribute name="data-pagefind-body" select="'data-pagefind-body'"/>
	    </xsl:if>
      <xsl:apply-templates select="@*"/>
      <!-- masthead -->
      <header class="sticky-top">
        <!-- menus read from menus.json -->
        <nav id="main-nav" class="navbar navbar-expand-md navbar-dark bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="{concat('/',$context,'/')}/">ACS</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"/>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
              <xsl:apply-templates select="$menus" mode="main-menu"/>
            </div>
          </div>
        </nav>
        <xsl:if test="div[@class='tei']">
          <nav id="doc-meta-nav" class="navbar navbar-expand-lg navbar-dark bg-dark-secondary">
            <div class="container-fluid">
              <ul class="navbar-nav d-flex flex-row flex-nowrap overflow-auto w-100">
                <li class="nav-item">
                  <a class="nav-link px-3" href="#doc-infoModal" data-bs-toggle="modal" id="doc-info-lnk">Document Information</a>
                </li>
                <xsl:if test="//meta[@name = 'parent_vol']">
                  <li class="nav-item">
                    <a class="nav-link px-3" data-bs-toggle="modal" href="#tocModal" id="vol-contents-lnk">Volume Contents</a>
                  </li>
                </xsl:if>
              </ul>
            </div>
          </nav>
        </xsl:if>
      </header>
      <!-- contextual sidebar of the menu to which this page belongs, if any -->
      <xsl:variable name="sub-menu">
        <xsl:call-template name="sub-menu"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$sub-menu/*">
          <section class="content">
            <xsl:copy-of select="$sub-menu"/>
            <div>
              <xsl:apply-templates select="node()"/>
            </div>
          </section>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- footer -->
      <xsl:call-template name="footer"/>
      <!-- link to local bootstrap js -->
      <script type="module" src="js/pageFindHighlight.js"/>
      <script src="js/bootstrap.bundle.min.js"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="sub-menu">
    <xsl:message select="concat('current uri = ', $current-uri)"/>
    <xsl:variable name="sub-menu" select="$menus/fn:map/fn:map[fn:string = $current-uri]"/>
    <xsl:if test="$sub-menu">
      <nav class="internal">
        <header>
          <xsl:value-of select="$sub-menu/@key"/>
        </header>
        <ul>
          <xsl:for-each select="$sub-menu/fn:string">
            <a class="dropdown-item" href="{.}">
              <!-- <xsl:if test=". = $current-uri">
							<xsl:attribute name="class">current</xsl:attribute>
						</xsl:if>-->
              <xsl:value-of select="@key"/>
            </a>
          </xsl:for-each>
        </ul>
      </nav>
    </xsl:if>
  </xsl:template>
  <xsl:template match="fn:map" mode="main-menu">
    <ul class="navbar-nav mr-auto">
      <xsl:apply-templates mode="main-menu"/>
    </ul>
  </xsl:template>
  <xsl:template match="fn:string" mode="main-menu">
    <li class="nav-item">
      <a class="nav-link" href="{concat('/',$context,.)}">
        <xsl:value-of select="@key"/>
      </a>
    </li>
  </xsl:template>
  <xsl:template match="fn:map[ancestor::fn:map]/fn:string" mode="main-menu">
    <a class="dropdown-item">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="starts-with(.,'http')">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('/',$context,.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="@key"/>
    </a>
  </xsl:template>
  <xsl:template match="fn:map/fn:map" mode="main-menu">
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <xsl:value-of select="@key"/>
      </a>
      <div class="dropdown-menu" aria-labelledby="navbarDropdown">
        <xsl:apply-templates mode="main-menu"/>
      </div>
    </li>
  </xsl:template>
  <xsl:template name="footer">
    <footer data-pagefind-ignore="all" class="footer mt-auto py-3 bg-dark text-light text-sansserif fs-70">
      <div class="container-fluid ml-0">
				Last Updated: 
            <xsl:value-of select="format-date(current-date(), '[D] [MNn] [Y]')"/>
<br/>
				
Copyright &#xA9; 1997-<xsl:value-of select="format-date(current-date(), '[Y]')"/>  by <a class="text-light" href="mailto:jawalsh@indiana.edu">John A. Walsh</a>
			</div>
    </footer>
  </xsl:template>
  <xsl:template match="div[@id = 'doc-meta']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="." mode="replace-class"/>
      <xsl:apply-templates select="*"/>
      <xsl:apply-templates select="*" mode="replace-class"/>
    </xsl:copy>
  </xsl:template>
  <!-- modal-ize #doc-info -->
  <xsl:template match="div[@id = 'doc-info']">
    <div class="modal" id="doc-infoModal" data-bs-keyboard="false" tabindex="-1" aria-labelledby="Document Information" aria-hidden="true">
      <div class="modal-dialog modal-fullscreen-sm-down modal-dialog-scrollable ">
        <div class="modal-content">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="." mode="replace-class"/>
            <xsl:apply-templates select="*"/>
          </xsl:copy>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
  <!-- add wrapper div elements for bootstrap-based layout -->
  <xsl:template match="div[@class='tei']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="." mode="replace-class"/>
      <div class="container">
        <!-- wrap the <cite> containing the page title, and the <div> containing the teiHeader-based metadata -->
        <!--
				<div class="row">
					<div class="col">
						<xsl:apply-templates select="cite | child::div[@id='doc-meta']"/>
					</div>
				</div>
						-->
        <!-- arrange the 'searchable-content' (i.e. the actual text) and the table of contents in a single row -->
        <div class="row mt-5">
          <div class="col">
            <xsl:apply-templates select="child::div[@class='searchable-content']"/>
          </div>
        </div>
        <xsl:if test="//meta[@name = 'parent_vol']">
          <div class="modal" id="tocModal" data-pagefind-ignore="all" data-bs-keyboard="false" tabindex="-1" aria-labelledby="Table of Contents" aria-hidden="true">
            <div class="modal-dialog modal-fullscreen-sm-down modal-dialog-scrollable ">
              <div class="modal-content">
                <!--	<xsl:apply-templates select="child::div[@id='toc']"/> -->
                <!-- if no *[@xml:id = 'parent-vol'] then not a collection with toc. Maybe. Have to figure out later what to do with internal table of contents, for e.g., Year's Letters, Blake, etc. -->
                <xsl:call-template name="toc"/>
                <div class="modal-footer">
                  <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Close</button>
                </div>
              </div>
            </div>
          </div>
        </xsl:if>
      </div>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="toc">
    <div id="toc">
      <!-- Iterate over the root array -->
      <ul>
        <li>
          <!-- Extract the volume title -->
          <xsl:value-of select="$volume/fn:string[@key='title']"/>
          <xsl:value-of select="concat(' (',$volume/fn:string[@key='date'],')')"/>
          <xsl:choose>
            <xsl:when test="$volume/fn:array[@key='works']/fn:map">
              <ul>
                <!-- Iterate over works if they exist -->
                <xsl:for-each select="$volume/fn:array[@key='works']/fn:map">
                  <li>
                    <xsl:if test="fn:map[@key = 'work']/fn:string[@key = 'id'] = $html-doc-id">
                      <xsl:attribute name="class">
                        <xsl:value-of select="'fw-bold'"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:comment>
                      <xsl:value-of select="concat('map-id: ', fn:map[@key = 'work']/fn:string[@key = 'id'])"/>
                    </xsl:comment>
                    <xsl:comment>
                      <xsl:value-of select="concat,('html-id: ',/html/@id)"/>
                    </xsl:comment>
                    <!-- Extract the work title -->
                    <a>
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
            </xsl:when>
            <xsl:when test="$volume/fn:array[@key='contents']/fn:map">
              <ul>
                <!-- Iterate over works if they exist -->
                <xsl:for-each select="$volume/fn:array[@key='contents']/fn:map">
                  <li>
                    <!-- Extract the work title -->
                    <a>
                      <xsl:attribute name="href">
                        <xsl:call-template name="generateInternalURL">
                          <xsl:with-param name="docID" select="$volume/fn:string[@key='id']"/>
                          <xsl:with-param name="ref" select="fn:map[@key='item']/fn:string[@key='id']"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:value-of select="fn:map[@key='item']/fn:string[@key='title']"/>
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
            </xsl:when>
            <xsl:otherwise>
              <li>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="generateURL">
                      <xsl:with-param name="docID" select="fn:map[@key='volume']/fn:string[@key='id']"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <!-- Extract the volume title -->
                  <xsl:value-of select="fn:map[@key='volume']/fn:string[@key='title']"/>
                </a>
                <xsl:value-of select="concat(' (',fn:map[@key='volume']/fn:string[@key='date'],')')"/>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </ul>
    </div>
  </xsl:template>
  <!-- add wrapper divs in the search and browse page -->
  <xsl:template match="main[@class='search']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <div class="container">
        <div class="search">
          <xsl:apply-templates/>
        </div>
      </div>
    </xsl:copy>
  </xsl:template>
  <!-- rearrange the content of the advanced-search form -->
  <xsl:template match="form[@id='advanced-search']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <div class="row">
        <div class="col-8">
          <div class="results mt-5 pe-5">
            <xsl:apply-templates select="child::div[@class='results']/node()"/>
          </div>
        </div>
        <div class="col-4">
          <div class="fields mt-5">
            <xsl:apply-templates select="child::div[@class='fields']/node()"/>
          </div>
          <div class="facets mt-5">
            <xsl:apply-templates select="child::div[@class='facets']/node()"/>
          </div>
        </div>
      </div>
    </xsl:copy>
  </xsl:template>
  <!-- this default template copies elements and uses a "replace-class" mode to add bootstrap @class attributes -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- some elements can acquire some bootstrap decoration here  -->
      <xsl:apply-templates select="." mode="replace-class"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <!-- the default bootstrap decoration is to do nothing; anything that needs decoration will have its own template below -->
  <xsl:template mode="replace-class" match="*"/>
  <!-- map semantic @class values to bootstrap @class values -->
  <xsl:template mode="replace-class" match="div[@class='tei']/div[@class='search']">
    <xsl:attribute name="class">search h-100</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="html[@class='search']">
    <xsl:attribute name="class">search h-100</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="html[@class='tei']">
    <xsl:attribute name="class">h-100</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="body[@class='tei']">
    <xsl:attribute name="class">d-flex flex-column h-100</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="div[@class='tei']">
    <xsl:attribute name="class">tei py-4</xsl:attribute>
  </xsl:template>
  <!-- identify project-docs that get regular headings -->
  <xsl:template mode="replace-class" match="h1[contains-token(@class, 'tei-head')]|h2[contains-token(@class, 'tei-head')]|h3[contains-token(@class, 'tei-head')]|h4[contains-token(@class, 'tei-head')]|h5[contains-token(@class, 'tei-head')]|h6[contains-token(@class, 'tei-head')]">
    <xsl:if test="/html/@xml:id = 'acs0000503-01' or /html/@xml:id = 'acs0000508-01'">
      <xsl:attribute name="class">
        <xsl:value-of select="concat(@class, ' project-doc')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template mode="replace-class" match="body[@class='search']">
    <xsl:attribute name="class">search d-flex flex-column h-100</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="main[@class='search']">
    <xsl:attribute name="class">search flex-shrink-0</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="main[@class='main']">
    <xsl:attribute name="class">flex-shrink-0</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="ul[@class='matching-snippets']">
    <xsl:attribute name="class">matching-snippets list-group</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="span[@class='bucket-cardinality']">
    <xsl:attribute name="class">bucket-cardinality badge bg-primary rounded-pill text-sansserif</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="ul[@class='pagination']">
    <xsl:attribute name="class">pagination justify-content-center text-sansserif</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="//div[contains-token(@class, 'tei-text')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' large-padding')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="//span[contains-token(@class, 'type-chorus')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' d-inline-block')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="//div[contains-token(@class, 'tei-epigraph')]|//div[contains-token(@class, 'tei-castList')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' my-4')"/>
    </xsl:attribute>
    </xsl:template>  
  <xsl:template mode="replace-class" match="//*[contains-token(@class, 'rendition-blockquote')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' my-2')"/>
    </xsl:attribute>
  </xsl:template>

  <!-- elements that should add bottom margin -->
  <xsl:template mode="replace-class" match="//div[contains-token(@class, 'tei-stage')]|//div[contains-token(@class, 'tei-sp')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' mb-4')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="//div[contains-token(@class, 'tei-castGroup')]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' mb-4')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="//div[contains-token(@class, 'tei-p')][. is ../div[contains-token(@class, 'tei-p')][1]]">
    <xsl:attribute name="class">
      <xsl:value-of select="concat(@class,' first-tei-p')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="div[@class='field']">
    <xsl:attribute name="class">mb-3</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="button[@class='search']">
    <xsl:attribute name="class">btn btn-primary</xsl:attribute>
  </xsl:template>
  <!-- Re-style elements created by p5-to-html.xsl -->
  <!-- bibliographic popups -->
  <xsl:template mode="replace-class" match="details[contains-token(@class, 'tei-bibl')]/summary">
    <xsl:attribute name="class">btn btn-primary</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="details[contains-token(@class, 'tei-bibl')]/ul">
    <xsl:attribute name="class">list-group list-group-flush</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="hr[contains-token(@class, 'tei-milestone')]">
    <xsl:attribute name="class">{@class} w-25 mb-4 m-auto</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="details[contains-token(@class, 'tei-bibl')]/ul/li">
    <xsl:attribute name="class">list-group-item</xsl:attribute>
  </xsl:template>
  <!-- teiHeader summary -->
  <xsl:template mode="replace-class" match="details[contains-token(@class, 'tei-teiHeader')]/summary">
    <xsl:attribute name="class">btn btn-outline-primary btn-sm</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="details[contains-token(@class, 'tei-teiHeader')]/div">
    <xsl:attribute name="class">expansion card card-body mt-3</xsl:attribute>
  </xsl:template>
  <!-- style lines to support label[@type = 'chorus'] -->
  <xsl:template mode="replace-class" match="//span[contains-token(@class, 'tei-l')]">
    <xsl:attribute name="class">{@class} position-relative</xsl:attribute>
  </xsl:template>
  <!-- hyperlinks which point to the next and previous search highlight -->
  <xsl:template mode="replace-class" match="a[@class = 'hit-link']">
    <xsl:attribute name="class">hit-link badge bg-secondary text-sansserif</xsl:attribute>
  </xsl:template>
  <!-- search and browse page -->
  <xsl:template mode="replace-class" match="button[contains-token(@class, 'bucket')]">
    <xsl:attribute name="class">{@class} list-group-item list-group-item-action d-flex justify-content-between align-items-center</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="div[@class = 'facet']">
    <xsl:attribute name="class">facet chart list-group mt-5</xsl:attribute>
  </xsl:template>
  <!-- teiHeader summary -->
  <xsl:template mode="replace-class" match="*[@id = 'doc-info']">
    <xsl:attribute name="class">{@class} px-4</xsl:attribute>
  </xsl:template>
  <!-- style headings in teiHeader Document Information -->
  <xsl:template mode="replace-class" match="div[contains-token(@class, 'tei-teiHeader')]//h1">
    <xsl:attribute name="class">{@class} h4</xsl:attribute>
  </xsl:template>
  <xsl:template mode="replace-class" match="div[contains-token(@class, 'tei-teiHeader')]//h2">
    <xsl:attribute name="class">{@class} h5</xsl:attribute>
    </xsl:template>
  <xsl:template match="li[@class='page-item active']/a[@class='page-link']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
      <span class="visually-hidden">(current)</span>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="generateURL">
    <xsl:param name="docID"/>
    <xsl:value-of select="concat('https://',$server,'/',$site-dir,'/',$docID,'.html')"/>
  </xsl:template>
  <xsl:template name="generateInternalURL">
    <xsl:param name="docID"/>
    <xsl:param name="ref"/>
    <xsl:value-of select="concat('https://',$server,'/',$site-dir,'/',$docID,'.html#',$ref)"/>
  </xsl:template>
  <!-- notes -->
  <xsl:template match="div[contains-token(@class, 'tei-note') and (@id) and not(contains-token(@class,'rendition-rester-en-place'))]">
    <!-- generate button  -->
	  <button type="button" class="btn btn-outline-primary p-1" style="font-size: .7rem; vertical-align: super;" data-bs-toggle="modal" data-bs-target="{concat('#m-',@id)}">&#x2020;</button>
    <!-- generate modal -->
	  <div class="modal fade" id="{concat('m-',@id)}" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5">Note</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"/>
          </div>
          <div class="modal-body">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
  <!-- pagefind -->
  <xsl:template match="script[@id='loadSearch']">
    <script src="js/pageFindLoadSearch.js"/>
  </xsl:template>
  <xsl:template match="/html/head/meta[@name = 'docDate']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="data-pagefind-filter">
        <xsl:value-of select="'date[content]'"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/html/body//header[contains-token(@class,'tei-head')][1]">
	  <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="data-pagefind-weight" select="'10'"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/html/head/meta[@name = 'docTitle']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="data-pagefind-meta" select="'title[content]'"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="pagefind-meta">
    <meta name="volume-title" data-pagefind-filter="collection[content]" content="{$volume-title}"/>
  </xsl:template>
</xsl:stylesheet>
