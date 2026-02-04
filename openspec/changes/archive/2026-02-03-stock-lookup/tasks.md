# Tasks: Stock Lookup

## 1. Setup & Dependencies

- [x] 1.1 Add `webmock` gem to Gemfile (test group)
- [x] 1.2 Add `dotenv-rails` gem for ENV management
- [x] 1.3 Create `.env.example` with `FINNHUB_API_KEY=your_key_here`
- [x] 1.4 Add `.env` to `.gitignore` (already present)
- [x] 1.5 Bundle install and verify

## 2. MarketData Domain - Exceptions

- [x] 2.1 Create `app/domains/market_data/` directory
- [x] 2.2 Create exception classes in `app/domains/market_data/app.rb`:
  - `MarketData::ApiError` (base class)
  - `MarketData::RateLimitError < ApiError`
  - `MarketData::AuthenticationError < ApiError`

## 3. MarketData Domain - FinnhubClient

- [x] 3.1 Create `FinnhubClient` as private nested class in `app.rb`
- [x] 3.2 Implement `#quote(symbol)` - fetches price, high, low, open, change
- [x] 3.3 Implement `#search(query)` - searches for symbols by company name
- [x] 3.4 Implement error handling (401, 429, 500, timeout)

## 4. MarketData Domain - App Facade

- [x] 4.1 Implement `MarketData::App.search_companies(query)` - delegates to FinnhubClient
- [x] 4.2 Implement `MarketData::App.get_price(symbol)` - upcases and delegates
- [x] 4.3 Add `private_constant :FinnhubClient`
- [x] 4.4 Write specs with WebMock stubs

## 5. Routes & Controller

- [x] 5.1 Add `resources :stocks, only: [:index, :show]` to routes
- [x] 5.2 Create `StocksController#index` - search form + results
- [x] 5.3 Create `StocksController#show` - quote by symbol
- [x] 5.4 Add error handling (rescue MarketData exceptions, show flash)
- [x] 5.5 Write request specs for controller actions

## 6. Views

- [x] 6.1 Create `app/views/stocks/index.html.erb` with search form and results table
- [x] 6.2 Create `app/views/stocks/show.html.erb` with price and details
- [x] 6.3 Add Turbo Frame for seamless search updates

## 7. Client-Side Validation

- [x] 7.1 Extend Stimulus form-validation controller
- [x] 7.2 Add validation for blank search query
- [x] 7.3 Write system spec for client-side validation

## 8. System Tests

- [x] 8.1 Write system spec: search by company name
- [x] 8.2 Write system spec: no results found
- [x] 8.3 Write system spec: view stock quote
- [x] 8.4 Write system spec: API error shows friendly message

## 9. Navigation & Integration

- [x] 9.1 Add "Stock Lookup" link to navigation
- [x] 9.2 Manual smoke test with real API key
- [x] 9.3 Verify all specs pass

---

**Total: 28 tasks**
