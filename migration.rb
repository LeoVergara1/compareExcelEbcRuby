require 'rubyXL'
require "uri"
require "json"
require "net/http"

url = URI("https://csb-proxy.masnominadigital.com/api/consubanco/qa/ebanking-utils-service/registerGeolocalization")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["X-IBM-Client-Id"] = "4efd3dab2430c1918b6e0e4f9409bafd"
request["Content-Type"] = "application/json"
request.body = JSON.dump({
  "geolocalizationRequestBO": {
    "applicationId": "ECSB",
    "bpId": "0005162302",
    "operationType": "1010",
    "channel": "VDC",
    "date": "2021-10-01",
    "hour": "15:00:00",
    "latitud": "19.4302678",
    "longitud": "-99.1373136",
    "ipAddress": "216.58.195.243",
    "deviceInfo": "Browser",
    "customFields": [
      {
        "fieldName": "Campo",
        "fieldValue": "Valor"
      }
    ]
  }
})

response = https.request(request)
puts response.read_body
