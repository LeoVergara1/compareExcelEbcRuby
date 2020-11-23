require 'rubyXL'

##((DEPTO+ +\d*)|INT)
def getInteriorNumber(chain)
  {
    :interior_number => chain.match(/(DEPTO|DPTOP|(INT DEPTO)|INT)+ +\d*/)&.to_s,
    :chain_without_interior_number => chain.gsub(/(DEPTO|DPTOP|INT)+ +\d*/, "")
  }
end

def getOutNumber(chain)
  result = chain.match(/\d+[a-zA-Z]/)&.to_s
  if chain.include? "SN"
    result = "SN"
  elsif result.nil?
    result = chain.match(/(((LT|C|NO|L)+ \d+)|(LT+\d*))/)&.to_s
    if result.nil?
      chain_with_out_mzn = chain_without_mzn = chain.gsub(/(((MZ|MZA)+ +\d*)|(MZ+\d*))/, "")
      result = chain_with_out_mzn.match(/(([0-9][0-9])|(^([0-9]))| ([0-9][0-9][0-9]))/)&.to_s
      chain = chain_with_out_mzn.gsub(/(([0-9][0-9])|(^([0-9]))| ([0-9][0-9][0-9]))/, "")
    end
  end
  {
    :outdoor_number => result,
    :chain_without_outdoor_number => chain
  }
end

def validateStreet(chain)
  result = getInteriorNumber(chain)
  interior_number = result[:interior_number]
  result_outdoor = getOutNumber(result[:chain_without_interior_number])
  outdoor_number = result_outdoor[:outdoor_number]
  {
    :street => result_outdoor[:chain_without_outdoor_number],
    :interior_number => interior_number,
    :outdoor_number => outdoor_number
  }
end
workbook = RubyXL::Parser.parse("DatosCargaClientesCarteraMuestra-Ajuste.xlsx")
worksheet = workbook[0]
listFromPaysheetProgram = []
worksheet.each do |cells|
  if cells[3]
    listFromPaysheetProgram << {
      :function => cells[3].value,
      :agrup => cells[2].value,
      :type_inter => cells[1].value,
      :group_auth => cells[0].value,
      :street_join => validateStreet(cells[29].value),
      :full_street => cells[29].value
    }
  end
end
titles = []
l =  listFromPaysheetProgram.find_all{ |i| i[:function] != nil}
workbookNew = RubyXL::Workbook.new
sheet = workbookNew.worksheets[0]
sheet.add_cell(0,0, "Calle Original")
sheet.add_cell(0,1, "Calle")
sheet.add_cell(0,2, "Numero interior")
sheet.add_cell(0,3, "Numero exterior")
l.each_with_index do |e, i|
  i = i +1
  sheet.add_cell(i,0, e[:full_street])
  sheet.add_cell(i,1, e[:street_join][:street])
  sheet.add_cell(i,2, e[:street_join][:interior_number])
  sheet.add_cell(i,3, e[:street_join][:outdoor_number])
end
workbookNew.write("file.xlsx")