require 'csv'

consHeader = <<~CONS_HEADER
<c01 id="aspace_Conventions" level="series">
  <did><unittitle>Conventions</unittitle></did>
CONS_HEADER
consData = CSV.read("../../Downloads/Box inventory - Cons.csv")
allBoxesData = CSV.read("../../Downloads/Box inventory - All boxes(2).csv")
allBoxesByCon=allBoxesData.group_by{|n|n[3]}
def indent(str, level)
  " "*level + (str||"").split("\n").join("\n"+" "*level)
end

consSection = consHeader + consData.flat_map{|e|
  [indent(e[8].slice(0..-11),2)] +
    (allBoxesByCon[e[1]]&.map{|ee| indent(ee[28],10)}||[]) +
    ["    </c03>"] unless e[8].nil?
}.join("\n").slice(9..-1) + "\n  </c02>\n</c01>"

print consSection
