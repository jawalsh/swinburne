for file in tei/*.xml; do
    java -jar common/lib/saxon/saxon-he-12.4.jar -s:"$file" -xsl:common/xslt/copy-and-replace.xsl -o:/tmp/tei-with-xi/$(basename "$file")
done
