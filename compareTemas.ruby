require 'rubyXL'
workbook = RubyXL::Parser.parse("Catalogo_de_temas_Asignaturas_con_examen_nuevo.xlsx")
worksheet = workbook[4]
#worksheet.each { |row|
#p worksheet
worksheet.each do |row|
  #p row
end

listFromPaysheetProgram = []
worksheet.each do |cells|
  if cells[4]
    listFromPaysheetProgram << {
      :title => cells[4].value
    }
  end
end

titles = []
l =  listFromPaysheetProgram.find_all{ |i| i[:title] != nil}
l.each do |e|
  rows = e[:title].split("\n")
  rows.each do |i|
    titles << "INSERT INTO APPGENEXA.TOPIC VALUES (APPGENEXA.SQ_ID_TOPIC.NEXTVAL, '#{i.gsub(/\s+$/,'')}', SYSDATE, SYSDATE);"
  end
end

File.write("insert.txt", titles.join("\n"), mode: "a")
