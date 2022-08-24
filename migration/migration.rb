require 'rubyXL'
require 'uri'
require 'json'
require 'net/http'
workbook = RubyXL::Parser.parse('TestMigration.xlsx')
worksheet = workbook[0]

listElments = []
worksheet.each do |cells|
  # p cells[28].value
  listElments << {
    bpId: cells[0]&.value,
    date: cells[1]&.value,
    hour: cells[2]&.value,
    latitud: cells[3]&.value,
    longitud: cells[4]&.value,
    ip: cells[5]&.value,
    deviceinfo: cells[6]&.value,
    canal: cells[7]&.value,
    solicitud: cells[8]&.value,
    geolocalizationId: '',
    response: ''
  }
end
listElments.delete_at(0)

url = URI('https://csb-proxy.masnominadigital.com/api/csb/qa/ebanking-utils-service/registerGeolocalization')

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request['X-IBM-Client-Id'] = '1b6637cb0917fb62b4c2ca5afa973157'
request['Content-Type'] = 'application/json'
listElments.each do |element|
  p element
  request.body = JSON.dump(
    {
      "geolocalizationRequestBO": {
        "applicationId": 'ECSB',
        "bpId": element[:bpId],
        "operationType": '1010',
        "channel": element[:canal],
        "date": element[:date],
        "hour": element[:hour],
        "latitud": element[:latitud].round(8),
        "longitud": element[:longitud].round(8),
        "ipAddress": element[:ip],
        "deviceInfo": element[:deviceinfo],
        "customFields": [
          {
            "fieldName": 'folio-solicitud',
            "fieldValue": element[:solicitud]
          }
        ]
      }
    }
  )
  response = https.request(request)
  p response
  element[:geolocalizationId] = JSON.parse(response.read_body)['geolocalizationResponseBO']['geolocalizationId']
  element[:response] = response
end

titles = []
workbookNew = RubyXL::Workbook.new
sheet = workbookNew.worksheets[0]
sheet.add_cell(0, 0, 'bpId')
sheet.add_cell(0, 1, 'date')
sheet.add_cell(0, 2, 'hour')
sheet.add_cell(0, 3, 'latitud')
sheet.add_cell(0, 4, 'longitud')
sheet.add_cell(0, 5, 'ip')
sheet.add_cell(0, 6, 'deviceinfo')
sheet.add_cell(0, 7, 'solicitud')
sheet.add_cell(0, 8, 'geolocalizationId')
sheet.add_cell(0, 9, 'response')
listElments.each_with_index do |e, i|
  p e
  i += 1
  sheet.add_cell(i, 0, e[:bpId])
  sheet.add_cell(i, 1, e[:date])
  sheet.add_cell(i, 2, e[:hour])
  sheet.add_cell(i, 3, e[:latitud])
  sheet.add_cell(i, 4, e[:longitud])
  sheet.add_cell(i, 5, e[:ip])
  sheet.add_cell(i, 6, e[:deviceinfo])
  sheet.add_cell(i, 7, e[:solicitud])
  sheet.add_cell(i, 8, e[:geolocalizationId])
  sheet.add_cell(i, 9, e[:response].body)
end
workbookNew.write('result.xlsx')
