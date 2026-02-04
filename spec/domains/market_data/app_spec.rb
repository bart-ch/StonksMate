require "rails_helper"

RSpec.describe MarketData::App do
  let(:api_key) { "test_api_key" }

  describe ".search_companies" do
    it "returns matching stocks" do
      stub_request(:get, "https://finnhub.io/api/v1/search")
        .with(query: { q: "Apple", token: api_key })
        .to_return(
          status: 200,
          body: {
            result: [
              { symbol: "AAPL", description: "Apple Inc", type: "Common Stock" },
              { symbol: "APLE", description: "Apple Hospitality REIT", type: "REIT" }
            ]
          }.to_json
        )

      results = described_class.search_companies("Apple")

      expect(results.length).to eq(2)
      expect(results.first[:symbol]).to eq("AAPL")
      expect(results.first[:name]).to eq("Apple Inc")
      expect(results.first[:type]).to eq("Common Stock")
    end

    it "returns empty array when no matches" do
      stub_request(:get, "https://finnhub.io/api/v1/search")
        .with(query: { q: "xyznonexistent", token: api_key })
        .to_return(status: 200, body: { result: [] }.to_json)

      results = described_class.search_companies("xyznonexistent")

      expect(results).to eq([])
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "https://finnhub.io/api/v1/search")
        .with(query: { q: "Apple", token: api_key })
        .to_return(status: 429, body: "")

      expect { described_class.search_companies("Apple") }.to raise_error(MarketData::Errors::RateLimitError)
    end
  end

  describe ".get_price" do
    it "returns stock quote data" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_return(
          status: 200,
          body: { c: 182.50, h: 183.20, l: 181.00, o: 181.50, pc: 180.00, d: 2.50, dp: 1.39 }.to_json
        )

      result = described_class.get_price("AAPL")

      expect(result[:symbol]).to eq("AAPL")
      expect(result[:price]).to eq(182.50)
      expect(result[:high]).to eq(183.20)
      expect(result[:low]).to eq(181.00)
      expect(result[:change]).to eq(2.50)
      expect(result[:change_percent]).to eq(1.39)
    end

    it "handles lowercase input" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "NVDA", token: api_key })
        .to_return(status: 200, body: { c: 500.00, h: 505.00, l: 495.00, o: 498.00, pc: 497.00 }.to_json)

      result = described_class.get_price("nvda")

      expect(result[:symbol]).to eq("NVDA")
      expect(result[:price]).to eq(500.00)
    end

    it "raises AuthenticationError on 401" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_return(status: 401, body: "")

      expect { described_class.get_price("AAPL") }.to raise_error(MarketData::Errors::AuthenticationError)
    end

    it "raises ApiError on 500" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_return(status: 500, body: "")

      expect { described_class.get_price("AAPL") }.to raise_error(MarketData::Errors::ApiError)
    end

    it "raises ApiError on network timeout" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_timeout

      expect { described_class.get_price("AAPL") }.to raise_error(MarketData::Errors::ApiError)
    end
  end
end
