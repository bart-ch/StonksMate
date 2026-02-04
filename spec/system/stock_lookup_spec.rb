require "rails_helper"

RSpec.describe "Stock Lookup", type: :system do
  before do
    driven_by(:selenium_headless)
  end

  describe "searching for stocks" do
    it "finds stocks by company name" do
      allow(MarketData::App).to receive(:search_companies).with("Apple").and_return([
        { symbol: "AAPL", name: "Apple Inc", type: "Common Stock" },
        { symbol: "APLE", name: "Apple Hospitality REIT", type: "REIT" }
      ])

      allow(MarketData::App).to receive(:get_price).and_return(
        { symbol: "AAPL", price: 182.50, change: 2.50, change_percent: 1.39 }
      )

      visit stocks_path
      fill_in "q", with: "Apple"
      click_button "Search"

      expect(page).to have_content("AAPL")
      expect(page).to have_content("Apple Inc")
    end

    it "shows no results message" do
      allow(MarketData::App).to receive(:search_companies).with("xyznonexistent").and_return([])

      visit stocks_path
      fill_in "q", with: "xyznonexistent"
      click_button "Search"

      expect(page).to have_content("No results found")
    end

    it "shows error message on API failure" do
      allow(MarketData::App).to receive(:search_companies).with("Apple").and_raise(MarketData::Errors::ApiError)

      visit stocks_path
      fill_in "q", with: "Apple"
      click_button "Search"

      expect(page).to have_content("Unable to fetch stock data")
    end
  end

  describe "viewing stock quote" do
    it "displays stock price and details" do
      allow(MarketData::App).to receive(:get_price).with("AAPL").and_return(
        { symbol: "AAPL", price: 182.50, high: 183.20, low: 181.00, open: 181.50, previous_close: 180.00, change: 2.50, change_percent: 1.39 }
      )

      visit stock_path("AAPL")

      expect(page).to have_content("AAPL")
      expect(page).to have_content("182.50")
      expect(page).to have_content("High")
      expect(page).to have_content("183.20")
    end
  end

  describe "client-side validation" do
    it "shows error for blank search without HTTP request" do
      visit stocks_path
      click_button "Search"

      expect(page).to have_content("Please enter a stock symbol or company name")
    end
  end
end
