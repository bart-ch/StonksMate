# MarketData Domain

## Feature: Search for companies

### Scenario: Search returns matching stocks

**Given** Finnhub search returns results for "Apple"
**When** calling `MarketData::App.search_companies("Apple")`
**Then** it returns an array of stocks with symbol, name, and type

### Scenario: Search with no matches returns empty array

**Given** Finnhub search returns no results for "xyznonexistent"
**When** calling `MarketData::App.search_companies("xyznonexistent")`
**Then** it returns an empty array

### Scenario: Search rate limit raises error

**Given** Finnhub API returns 429 (rate limit exceeded)
**When** calling `MarketData::App.search_companies("Apple")`
**Then** it raises `MarketData::Errors::RateLimitError`

## Feature: Get stock price

### Scenario: Get price returns stock data

**Given** Finnhub returns a valid quote for "AAPL"
**When** calling `MarketData::App.get_price("AAPL")`
**Then** it returns a hash with symbol, price, high, low, open, previous_close, change, change_percent

### Scenario: Get price handles lowercase input

**Given** Finnhub returns a valid quote for "NVDA"
**When** calling `MarketData::App.get_price("nvda")`
**Then** it upcases the symbol and returns the quote

### Scenario: Get price authentication error

**Given** Finnhub API returns 401 (unauthorized)
**When** calling `MarketData::App.get_price("AAPL")`
**Then** it raises `MarketData::Errors::AuthenticationError`

### Scenario: Get price server error

**Given** Finnhub API returns 500 (server error)
**When** calling `MarketData::App.get_price("AAPL")`
**Then** it raises `MarketData::Errors::ApiError`

### Scenario: Get price network timeout

**Given** Finnhub API request times out
**When** calling `MarketData::App.get_price("AAPL")`
**Then** it raises `MarketData::Errors::ApiError`

## Testing Notes

- Use WebMock to stub Finnhub API HTTP calls
- Test API key is loaded from ENV
