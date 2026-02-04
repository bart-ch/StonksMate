require "net/http"
require "json"

module MarketData
  class FinnhubClient
    BASE_URL = "https://finnhub.io/api/v1"

    def initialize(api_key = ENV["FINNHUB_API_KEY"])
      @api_key = api_key
    end

    def quote(symbol)
      response = get("/quote", symbol: symbol)
      {
        symbol: symbol.upcase,
        price: response["c"],
        high: response["h"],
        low: response["l"],
        open: response["o"],
        previous_close: response["pc"],
        change: response["d"],
        change_percent: response["dp"]
      }
    end

    def search(query)
      response = get("/search", q: query)
      (response["result"] || []).map do |item|
        {
          symbol: item["symbol"],
          name: item["description"],
          type: item["type"]
        }
      end
    end

    private

    def get(path, params = {})
      uri = URI("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params.merge(token: @api_key))

      response = Net::HTTP.get_response(uri)
      handle_response(response)
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError
      raise Errors::ApiError
    end

    def handle_response(response)
      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        raise Errors::AuthenticationError
      when 429
        raise Errors::RateLimitError
      else
        raise Errors::ApiError
      end
    end
  end
end
