class ElToqueApi
  BASE_URL = "https://tasas.eltoque.com"
  ENDPOINT = "/v1/trmi"

  class MissingTokenError < StandardError; end
  class ApiError < StandardError; end

  CURRENCY_MAP = {
    "USD" => :usd_cup,
    "EUR" => :eur_cup,
    "CLA" => :cla_cup,
    "ZELLE" => :zelle_cup
  }.freeze

  def self.fetch_rates
    token = ENV["EL_TOQUE_API_TOKEN"]
    raise MissingTokenError, "EL_TOQUE_API_TOKEN no está configurado" if token.blank?

    uri = URI("#{BASE_URL}#{ENDPOINT}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 10

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{token}"

    response = http.request(request)

    raise ApiError, "Error HTTP #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPOK)

    data = JSON.parse(response.body)
    rates = data["tasas"] || data

    result = { date: Date.current }
    CURRENCY_MAP.each do |api_key, db_column|
      value = rates[api_key]
      result[db_column] = value if value
    end

    result
  rescue Net::TimeoutError, Timeout::Error => e
    raise ApiError, "Timeout de conexión: #{e.message}"
  end
end
