require 'rubyXL'
workbook = RubyXL::Parser.parse("plataforma-de-negocios.xlsx")
worksheet = workbook[0]
#worksheet.each { |row|
#p worksheet
worksheet.each do |row|
  #p row
end

listFromPaysheetProgram = []
worksheet.each do |cells|
  if cells[3]
    listFromPaysheetProgram << {
      :title => cells[3].value,
      :unity => cells[2].value,
      :subject => cells[1].value,
      :key => cells[0].value
    }
  end
end

titles = []
l =  listFromPaysheetProgram.find_all{ |i| i[:title] != nil}
l.each do |e|
  rows = e[:title].split("\n")
  rows.each do |i|
    p e
    titles << "INSERT INTO APPGENEXA.TOPIC VALUES (APPGENEXA.SQ_ID_TOPIC.NEXTVAL, '#{i.gsub(/\s+$/,'')}', '#{e[:unity].gsub(/\s+$/,'')}', '#{e[:subject].gsub(/\s+$/,'')}', '#{e[:key].gsub(/\s+$/,'')}', SYSDATE, SYSDATE);"
  end
end

File.write("insert.txt", titles.join("\n"), mode: "a")
