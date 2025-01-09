<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:tei="http://www.tei-c.org/ns/1.0"
    queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern id="contentDesc">
        
        
        
        <sch:rule context="tei:div[@type = 'contentDesc']">
            <sch:let name="parentID" value="ancestor::tei:div[@type = 'issue'][1]/@xml:id"/>
            <sch:assert test="substring-before(@xml:id,'_') = $parentID">Content description @xml:id has prefix matching issue ID.</sch:assert>
            <sch:assert test="child::*[position()=1][local-name() = 'bibl'][starts-with(normalize-space(.),'p. ') or starts-with(normalize-space(.),'pp. ')]">The content description includes a 
                bibl as the first child, and bibl starts with "p." or "pp."</sch:assert>
            <sch:assert test="tei:list[@type = 'gloss'] or tei:list[@copyOf]">The content description includes a gloss
                list or points to a gloss list via @copyOf.</sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:list[@type = 'gloss']/tei:label[. = 'title']">
            <sch:assert
                test="following-sibling::tei:item[position() = 1][not(normalize-space(.) = '')] or following-sibling::tei:item[preceding-sibling::tei:label[position() = 1][normalize-space(.) = 'incipit']][not(normalize-space(.) = '')]">List includes non-empty title or non-empty incipit.</sch:assert>
        </sch:rule>
        
        
        <sch:rule context="tei:list[@type = 'gloss']/tei:label[. = 'creator']">
            <sch:assert
                test="following-sibling::tei:item[position() = 1][not(normalize-space(.) = '')]"
                >List includes non-empty creator.</sch:assert>
        </sch:rule>
        
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
        
        <sch:rule context="tei:list[@type = 'gloss']/tei:label[. = 'reader-contributed content']">
            <sch:assert
                test="following-sibling::tei:item[position() = 1][(normalize-space(.) = 'y') or (normalize-space(.) = 'n') or (normalize-space(.) = 'u') or (normalize-space(.) = 'd')]"
                >reader-contributed content = 'y' or 'n' or 'u' (unknown) or 'd' (discussed).</sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:list[@type = 'gloss']">
            <sch:assert
                test="tei:label[position() = 1 and normalize-space(.) = 'title']"
                >First label is not title.</sch:assert>
            <sch:assert
                test="tei:label[position() = 2 and normalize-space(.) = 'incipit']"
                >Second label is not incipit.</sch:assert>
            <sch:assert
                test="tei:label[position() = 3 and normalize-space(.) = 'description']"
                >Third label is not description.</sch:assert>
            <sch:assert
                test="tei:label[position() = 4 and normalize-space(.) = 'creator']"
                >Fourth label is not creator.</sch:assert>
            <sch:assert
                test="tei:label[position() = 5 and normalize-space(.) = 'recurring feature']"
                >Fifth label is not recurring feature.</sch:assert>
            <sch:assert
                test="tei:label[position() = 6 and normalize-space(.) = 'genre']"
                >Sixth label is not genre.</sch:assert>
            <sch:assert
                test="tei:label[position() = 7 and normalize-space(.) = 'reader-contributed content']"
                >Seventh label is not reader-contributed content.</sch:assert>
            <sch:assert
                test="tei:label[position() = 8 and normalize-space(.) = 'notes']"
                >Eighth label is not notes.</sch:assert>
        </sch:rule>
        
        <sch:rule context="tei:list[@type = 'gloss']/tei:item[preceding-sibling::tei:label[position() = 1 and . = 'genre']]">
            <sch:assert test="@corresp">genre item requires @corresp.</sch:assert>
        </sch:rule>
        
        
        
        
        
        <!-- 
                     <div xml:id="">
            <head><bibl></bibl></head>
            <list type="gloss">
               <label>title</label>
               <item></item>
               <label>incipit</label>
               <item></item>
               <label>description</label>
               <item></item>
               <label>creator</label>
               <item></item>
               <label>recurring feature</label>
               <item></item>
               <label>genre</label>
               <item corresp="#editorial"/>
               <label>reader-contributed content</label>
               <item></item>
               <label>notes</label>
               <item></item>
            </list>
         </div> 
         -->
    </sch:pattern>
</sch:schema>
