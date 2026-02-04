require "rails_helper"

RSpec.describe "Stocks", type: :request do
  let(:api_key) { "test_api_key" }

  describe "GET /stocks" do
    it "renders the search form" do
      get stocks_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Stock Lookup")
    end

    context "with a search query" do
      it "displays search results with prices" do
        stub_request(:get, "https://finnhub.io/api/v1/search")
          .with(query: { q: "Apple", token: api_key })
          .to_return(
            status: 200,
            body: {
              result: [
                { symbol: "AAPL", description: "Apple Inc", type: "Common Stock" }
              ]
            }.to_json
          )

        stub_request(:get, "https://finnhub.io/api/v1/quote")
          .with(query: { symbol: "AAPL", token: api_key })
          .to_return(status: 200, body: { c: 182.50, h: 183.20, l: 181.00, o: 181.50, pc: 180.00, d: 2.50, dp: 1.39 }.to_json)

        get stocks_path, params: { q: "Apple" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("AAPL")
        expect(response.body).to include("Apple Inc")
        expect(response.body).to include("182.50")
      end

      it "shows no results message when nothing found" do
        stub_request(:get, "https://finnhub.io/api/v1/search")
          .with(query: { q: "xyznonexistent", token: api_key })
          .to_return(status: 200, body: { result: [] }.to_json)

        get stocks_path, params: { q: "xyznonexistent" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("No results found")
      end

      it "shows error message on API failure" do
        stub_request(:get, "https://finnhub.io/api/v1/search")
          .with(query: { q: "Apple", token: api_key })
          .to_return(status: 500, body: "")

        get stocks_path, params: { q: "Apple" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Unable to fetch stock data")
      end
    end
  end

  describe "GET /stocks/:id" do
    it "displays stock quote" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_return(status: 200, body: { c: 182.50, h: 183.20, l: 181.00, o: 181.50, pc: 180.00, d: 2.50, dp: 1.39 }.to_json)

      get stock_path("AAPL")

      expect(response).to have_http_status(:success)
      expect(response.body).to include("AAPL")
      expect(response.body).to include("182.50")
    end

    it "handles lowercase symbol" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "NVDA", token: api_key })
        .to_return(status: 200, body: { c: 500.00, h: 505.00, l: 495.00, o: 498.00, pc: 497.00 }.to_json)

      get stock_path("nvda")

      expect(response).to have_http_status(:success)
      expect(response.body).to include("NVDA")
      expect(response.body).to include("500.00")
    end

    it "redirects with error for invalid symbol" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "XXXX", token: api_key })
        .to_return(status: 200, body: { c: 0, h: 0, l: 0, o: 0, pc: 0 }.to_json)

      get stock_path("XXXX")

      expect(response).to redirect_to(stocks_path)
      follow_redirect!
      expect(response.body).to include("Stock not found")
    end

    it "redirects with error on API failure" do
      stub_request(:get, "https://finnhub.io/api/v1/quote")
        .with(query: { symbol: "AAPL", token: api_key })
        .to_return(status: 500, body: "")

      get stock_path("AAPL")

      expect(response).to redirect_to(stocks_path)
    end
  end
end
