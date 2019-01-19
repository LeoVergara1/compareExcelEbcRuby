require 'rubyXL'
workbook = RubyXL::Parser.parse("period 2.xlsx")
worksheet = workbook[0]
workbook2 = RubyXL::Parser.parse("postgres1.xlsx")
worksheet2 = workbook2[0]
#worksheet.each { |row|
#   row && row.cells.each { |cell|
#     val = cell && cell.value
#     p val
#   }
#}
worksheet.each do |row|
  row.cells
end

listRowsMap = []
#worksheet[0].cells.each do |cell|
#  p cell.value
#  {
#    :nrc =>
#  }
#end
listFromPaysheet = []
worksheet.each do |cells|
  #p cells[28].value
  listFromPaysheet << {
    :nrc => cells[13].value,
    :start_date => cells[17].value,
    :end_date => cells[18].value,
    :begin_time => cells[19].value,
    :end_time => cells[20].value,
    :days => [cells[22].value,cells[23].value,cells[24].value,cells[25].value,cells[26].value, cells[27].value,cells[28].value]
  }
end
listFromPaysheetBroker = []
worksheet2.each do |cells|
  #p cells[5]&.value
  listFromPaysheetBroker << {
    :nrc => cells[0].value,
    :start_date => cells[1].value,
    :end_date => cells[2].value,
    :begin_time => cells[3].value,
    :end_time => cells[4].value,
    :days => [cells[5]&.value,cells[6]&.value,cells[7]&.value,cells[8]&.value,cells[9]&.value,cells[10]&.value, cells[11]&.value]
  }
end
p listFromPaysheet[0]
p listFromPaysheetBroker[2]
p listFromPaysheet[0][:days]
p listFromPaysheetBroker[21][:days]
p listFromPaysheet[0] == listFromPaysheetBroker[2]
p listFromPaysheetBroker.select {|element| element[:nrc] == 3002 }

listDifferences = []
listFromPaysheet.each do |fromExcel|
  nrcs = listFromPaysheetBroker.select do |element|
    element[:nrc] == fromExcel[:nrc]
  end
 # nrcs.each do |nrc|
 #   if nrc == fromExcel then
 #     break
 #   else
 #     listDifferences << fromExcel
 #   end
 # end
  if nrcs.include? fromExcel
  else
    listDifferences << fromExcel
  end
end
p "No estan iguales"
p "*"*100
p listDifferences