require 'csv'

eadHeader = <<~EAD_HEADER
<?xml version="1.0" encoding="utf-8"?>
<ead xmlns="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd">
    <eadheader countryencoding="iso3166-1" dateencoding="iso8601" findaidstatus="in_progress" langencoding="iso639-2b"
               repositoryencoding="iso15511">
        <eadid>filk</eadid>
        <filedesc>
            <titlestmt>
                <titleproper>Harold Stein Filk Collection
                </titleproper>
                <author>Finding aid prepared by Merav Hoffman and Stacy Haponik.</author>
            </titlestmt>
            <publicationstmt>
                <publisher>Harold Stein Filk Archive</publisher>
            </publicationstmt>
        </filedesc>
        <profiledesc>
            <creation>This finding aid was produced using ArchivesSpace on <date>2020-01-18 16:49:04 -0500</date>.
            </creation>
            <langusage>eng</langusage>
        </profiledesc>
    </eadheader>
    <archdesc level="collection">
        <did>
            <repository>
                <corpname>Harold Stein Filk Archive</corpname>
            </repository>
            <unittitle>Harold Stein Filk Collection</unittitle>
            <unitid>filk</unitid>
            <physdesc altrender="whole">
                <extent altrender="materialtype spaceoccupied">34 boxes and an unknown number of terrabytes</extent>
            </physdesc>
            <unitdate normal="1960/2020" type="inclusive">1960-2020</unitdate>
            <abstract id="aspace_91dce08938ef1f39bd624e8f9513c913">Harold Stein was an active member of the Filking
                community. He amassed a large collection of filk songs, zines, convention papers, and audio recordings.
            </abstract>
            <physloc id="aspace_873db61850f4851afa7ef6e3459ff158">Private residence</physloc>
            <langmaterial id="aspace_e6be7cc4064631dc792debcdadaafbae">English</langmaterial>
        </did>
        <scopecontent id="aspace_cc6067d1986733d6535bf1291d2841c0">
            <head>Scope and Content</head>
            <p>
                <note>The Harold Stein Filk Collection contains....</note>
            </p>
        </scopecontent>
        <odd id="aspace_130ebf8ad5ca75cf79b4b109e57663ef">
            <head>General</head>
            <p>The Harold Stein Filk Collection contains....</p>
        </odd>
        <userestrict id="aspace_ref10">
            <head>Restrictions on Use</head>
            <p>
                <note>Most materials within the collection are within copyright. Permission to duplicate these materials
                    is governed by United States copyright law.
                </note>
            </p>
        </userestrict>
        <accessrestrict id="aspace_ref295">
            <head>Access</head>
            <p>
                <note>The collection is open and available for research.</note>
            </p>
        </accessrestrict>
        <controlaccess>
            <genreform authfilenumber="http://id.loc.gov/authorities/genreForms/gf2017026050.html" source="lcsh">Filk
                Music
            </genreform>
        </controlaccess>
        <dsc>
EAD_HEADER
consHeader = <<~CONS_HEADER
<c01 id="aspace_Conventions" level="series">
  <did><unittitle>Conventions</unittitle></did>
CONS_HEADER
consData = CSV.read("../../Downloads/Box inventory - Cons.csv")
allBoxesData = CSV.read("../../Downloads/Box inventory - All boxes(2).csv")
allBoxesByCon = allBoxesData.group_by{|n|n[3]}
allBoxesByBucket = allBoxesByCon[nil].group_by{|x|(x[18]&.split('.')||[""])[0]}

def indent(str, level)
  " "*level + (str||"").split("\n").join("\n"+" "*level)
end

consSection = consHeader + consData.flat_map{|e|
  [indent(e[8].slice(0..-11),2)] +
    (allBoxesByCon[e[1]]&.map{|ee| indent(ee[28],10)}||[]) +
    [" "*6 + "</c03>"] unless e[8].nil? or e[8].include?("<unittitle><")
}.join("\n").slice(9..-1) + "\n  </c02>\n</c01>"

otherBucketsSection = allBoxesByBucket.flat_map{|e|
  ["<c01>\n  <did><unittitle>#{e[0]}</unittitle></did>\n"] +
    e[1].group_by{|x|(x[18]&.split('.')||[""])[1]}&.flat_map{|f|
    ["  <c02>\n    <did><unittitle>#{f[0]}</unittitle></did>\n"] +
      (f[1]&.map{|ee|indent(ee[28],4) unless ee[28].include?("<unittitle><")}||[]) +
      ["\n  </c02>"] unless f[0].nil? or f[0].empty?} +
    ["\n</c01>"] unless e[0].empty?}.join("\n")

print eadHeader + consSection + otherBucketsSection + "\n       </dsc>\n    </archdesc>\n</ead>"
