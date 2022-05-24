require 'rubyXL'
workbook = RubyXL::Parser.parse('codigos_error_riesgosvetel.xlsx')
worksheet = workbook[0]

worksheet = worksheet.drop(1)
list_rows_map = []
worksheet.each do |cells|
  list_rows_map << {
    code: cells[1].value,
    description: cells[2].value,
    property: cells[3].value,
    type_component: cells[4]&.value
  }
end

p list_rows_map[0]

string_to_print = '{'

list_rows_map.each do |row|
  string_to_print << "
    #{row.dig(:code)}: {
        codigo: '#{row.dig(:code)}',
        descripcion: '#{row.dig(:description)}',
        property: '#{row.dig(:property)}',
        typeComponent: '#{row.dig(:type_component)}'
        },
  "
end

string_to_print << '}'



File.write("result_convert.js", string_to_print)