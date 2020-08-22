require 'rubyXL'
workbook = RubyXL::Parser.parse("PROG SOC 1806.xlsx")
worksheet = workbook[0]
workbook2 = RubyXL::Parser.parse("ADRI AM.xlsx")
worksheet2 = workbook2[0]
#worksheet.each { |row|
#   row && row.cells.each { |cell|
#     val = cell && cell.value
#     p val
#   }
#}
worksheet.each do |row|
  #p row.cells
end

listRowsMap = []
#worksheet[0].cells.each do |cell|
#  p cell.value
#  {
#    :nrc =>
#  }
#end

listFromPaysheetProgram = []
listFromPaysheetListNutrion = []
worksheet.each do |cells|
  #p cells[28].value
  listFromPaysheetProgram << {
    :last_name => cells[2].value,
    :second_name => cells[3].value,
    :names => cells[4].value,
  }
end

worksheet2.each do |cells|
  #p cells[28].value
  listFromPaysheetListNutrion << {
    :last_name => cells[2].value,
    :second_name => cells[3].value,
    :names => cells[4].value,
  }
end

result = []
listFromPaysheetListNutrion.each do |e|
  if listFromPaysheetProgram.include?(e) then
    result << e
  end
end


p "Primer lista"
p listFromPaysheetProgram.size
p listFromPaysheetProgram[1]
p "************"
p "Segunda lista"
p listFromPaysheetListNutrion.size
p listFromPaysheetListNutrion[1]
p "Resultado: Del cruce"
p result.size
result.each do |e|
  p e
end