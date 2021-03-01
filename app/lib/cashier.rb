require 'net/http'
require 'uri'

class Cashier
  RECEIVER_TOKEN_MAPPING = {
    'none'    => 'M9KRQ7rCWo845vqnFQ5jlZ4wU2h',
    'expedia' => 'NFTvfvUxrK862Sujkv7PZedvdWO'
  }

  def initialize(token, amount, receiver)
    @card_token = token
    @amount = amount
    @receiver = receiver
    @errors = []
  end

  def call
    url = build_url

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.basic_auth "#{ENV["SPREEDLY_ENVIRONMENT_KEY"]}", "#{ENV["SPREEDLY_ACCESS_SECRET"]}"
    request.body = JSON.generate(build_body)
    
    response = https.request(request)
    parsed_response = JSON.parse(response.body)
    @errors = parsed_response['errors'].map { |e| e['message'] } if parsed_response['errors']

    Response.new(parsed_response, @errors)
  end

  private

  def build_body
    case @receiver
    when 'none'
      {
        "transaction" => {
          "payment_method_token": @card_token,
          "amount": @amount,
          "currency_code": "USD"
        }
      }
    when 'expedia'
      body = JSON.generate({ "flight_number"=>1, "amount"=>@amount, "card_number"=>"{{ credit_card_number }}"})
      {
        "delivery" => {
          "payment_method_token": @card_token,
          "url": "https://www.expedia.com",
          "headers": "Content-Type: application/json",
          "body": body
        }
      }
    end
  end

  def build_url
    env_token = RECEIVER_TOKEN_MAPPING[@receiver]
    type, endpoint = @receiver == 'none' ? ['gateways', 'purchase'] : ['receivers', 'deliver']

    URI("https://core.spreedly.com/v1/#{type}/#{env_token}/#{endpoint}.json")
  end

  Response = Struct.new(:subject, :errors) do
    def success?
      errors.nil? || errors.empty?
    end

    def errors?
      errors.present?
    end
  end
end