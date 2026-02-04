# Stock Lookup

## Feature: Search stocks by company name

### Scenario: Search returns matching symbols with prices

**Given** the user is on the stocks page
**When** they enter "Apple" in the search field and submit
**Then** they see a list of matching symbols (AAPL, APLE, etc.)
**And** each result shows symbol, name, price, and change

### Scenario: Empty search shows no results

**Given** the user is on the stocks page
**When** they submit the form without entering a query
**Then** they see a validation error without an HTTP request

### Scenario: No results found

**Given** the user is on the stocks page
**When** they enter "xyznonexistent123" and submit
**Then** they see a "No results found" message

## Feature: View stock quote

### Scenario: View quote by symbol

**Given** the user navigates to /stocks/AAPL
**Then** they see the current price for AAPL
**And** they see high, low, open, previous close
**And** they see price change and change percent

### Scenario: Quote handles lowercase symbol

**Given** the user navigates to /stocks/nvda
**Then** they see the quote for NVDA (uppercase)

### Scenario: Invalid symbol shows error

**Given** the user navigates to /stocks/XXXX
**Then** they are redirected to the search page
**And** they see a "Stock not found" message

## Feature: API error handling

### Scenario: Finnhub API is unavailable

**Given** the Finnhub API returns 500
**When** the user searches or views a quote
**Then** they see a friendly error message "Unable to fetch stock data. Please try again."

### Scenario: Rate limit exceeded

**Given** the Finnhub API returns 429
**When** the user searches or views a quote
**Then** they see "API rate limit exceeded. Please try again later."

## Testing Notes

- Use WebMock to stub Finnhub API responses
- Test both search and quote endpoints
- System tests for full user flow
- Request specs for controller behavior
