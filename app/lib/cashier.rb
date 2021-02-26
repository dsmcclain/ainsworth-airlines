require 'net/http'
require 'uri'

class Cashier
  def initialize(token, amount)
    @token = token
    @amount = amount
  end

  def call
    url = URI("https://core.spreedly.com/v1/gateways/NFff8EbOnDcuhe7v6M0n6SzmhF2/purchase.json")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.basic_auth "#{ENV["SPREEDLY_KEY"]}", "#{ENV["SPREEDLY_ACCESS_SECRET"]}"
    request.body = JSON.generate(
      {
        "transaction" => {
          "payment_method_token": @token,
          "amount": @amount,
          "currency_code": "USD"
        }
      }
    )
    
    response = https.request(request)
    response.read_body
  end
end