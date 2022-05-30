require 'rubyXL'
require "uri"
require "json"
require "net/http"
workbook = RubyXL::Parser.parse("ArchivoEjemploParaEjecutarServicio.xlsx")
worksheet = workbook[0]

listElments = []
worksheet.each do |cells|
  #p cells[28].value
  listElments << {
    :bpId => cells[0].value,
    :date => cells[1].value,
    :hour => cells[2].value,
    :latitud => cells[3].value,
    :ip => cells[4].value,
    :deviceinfo => cells[5].value,
    :solicitud => cells[6].value,
    :geolocalizationId => ""
  }
end
listElments.delete_at(0)

url = URI("https://csb-proxy.masnominadigital.com/api/consubanco/qa/ebanking-utils-service/registerGeolocalization")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["X-IBM-Client-Id"] = "4efd3dab2430c1918b6e0e4f9409bafd"
request["Content-Type"] = "application/json"
listElments.each do |element|
  request.body = JSON.dump({
    "geolocalizationRequestBO": {
      "applicationId": "ECSB",
      "bpId": element[:bpId],
      "operationType": "1010",
      "channel": "VDC",
      "date": element[:date],
      "hour": element[:hour],
      "latitud": element[:latitud],
      "longitud": element[:longitud],
      "ipAddress": element[:ip],
      "deviceInfo": element[:deviceinfo],
      "customFields": [
        {
          "fieldName": "Campo",
          "fieldValue": "Valor"
        }
      ]
    }
  })
  response = https.request(request)
  element[:geolocalizationId] = JSON.parse(response.read_body)["geolocalizationResponseBO"]["geolocalizationId"]
end


titles = []
workbookNew = RubyXL::Workbook.new
sheet = workbookNew.worksheets[0]
sheet.add_cell(0,0, "bpId")
sheet.add_cell(0,1, "date")
sheet.add_cell(0,2, "hour")
sheet.add_cell(0,3, "latitud")
sheet.add_cell(0,4, "ip")
sheet.add_cell(0,5, "deviceinfo")
sheet.add_cell(0,6, "solicitud")
sheet.add_cell(0,7, "geolocalizationId")
listElments.each_with_index do |e, i|
  p e
  i = i +1
  sheet.add_cell(i,0, e[:bpId])
  sheet.add_cell(i,1, e[:date])
  sheet.add_cell(i,2, e[:hour])
  sheet.add_cell(i,3, e[:latitud])
  sheet.add_cell(i,4, e[:ip])
  sheet.add_cell(i,5, e[:deviceinfo])
  sheet.add_cell(i,6, e[:solicitud])
  sheet.add_cell(i,7, e[:geolocalizationId])
end
workbookNew.write("result.xlsx")
