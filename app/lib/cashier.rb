require 'net/http'
require 'uri'

class Cashier
  RECEIVER_TOKEN_MAPPING = {
    'none'    => 'M9KRQ7rCWo845vqnFQ5jlZ4wU2h',
    'expedia' => 'NFTvfvUxrK862Sujkv7PZedvdWO'
  }

  def initialize(token, options={})
    @card_token = token
    @amount = options[:amount]
    @receiver = options[:receiver]
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
    
    format_response(https.request(request))
  end

  def retain
    url = URI("https://core.spreedly.com/v1/payment_methods/#{@card_token}/retain.json")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"
    request.basic_auth "#{ENV["SPREEDLY_ENVIRONMENT_KEY"]}", "#{ENV["SPREEDLY_ACCESS_SECRET"]}"

    format_response(https.request(request))
  end

  def list_payment_methods
    url = URI("https://core.spreedly.com/v1/payment_methods.json")

    spreedly_get(url)
  end

  def list_transactions
    url = URI("https://core.spreedly.com/v1/transactions.json")

    spreedly_get(url)
  end

  private

  def spreedly_get(url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = "application/json"
    request.basic_auth "#{ENV["SPREEDLY_ENVIRONMENT_KEY"]}", "#{ENV["SPREEDLY_ACCESS_SECRET"]}"
    
    format_response(https.request(request))
  end

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

  def format_response(response)
    parsed_response = JSON.parse(response.body)
    @errors = parsed_response['errors'].map { |e| e['message'] } if parsed_response['errors']

    Response.new(parsed_response, @errors)
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