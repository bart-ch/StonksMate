module MarketData
  class App
    def self.search_companies(query)
      client = FinnhubClient.new
      client.search(query)
    end

    def self.get_price(symbol)
      client = FinnhubClient.new
      client.quote(symbol.upcase)
    end
  end
end
