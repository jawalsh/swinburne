<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:tei="http://www.tei-c.org/ns/1.0"
    queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern id="swinburne">
	    <sch:rule context="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:profileDesc">
	    <!-- <sch:let name="parentID" value="ancestor::tei:div[@type = 'issue'][1]/@xml:id"/> -->
            <sch:assert test="tei:catRef[@xml:id = 'parent_vol']">Missing parent volume in catRef.</sch:assert>
            </sch:rule>
        
	    <!--
        <sch:rule context="tei:list[@type = 'gloss']/tei:item[@corresp]">
            <sch:let name="tokens" value="for $w in tokenize(@corresp, '\s+') return substring-after($w, '#')"/>
            <sch:let name="catIDs" value="//tei:category/@xml:id"/>
            <sch:assert test="every $token in $tokens satisfies $token = $catIDs">
                Every pointer in @corresp must reference a category's xml:id!
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:list[@type = 'gloss']/tei:label[. = 'recurring feature']">
            <sch:assert
                test="following-sibling::tei:item[position() = 1][(normalize-space(.) = 'y') or (normalize-space(.) = 'n') or (normalize-space(.) = 'u')]"
                >recurring feature = 'y' or 'n' or 'u' (unknown).</sch:assert>
        </sch:rule>
        
	    -->
    </sch:pattern>
</sch:schema>
