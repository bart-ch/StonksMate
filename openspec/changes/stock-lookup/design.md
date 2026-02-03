## Context

Users need to look up stock prices before adding to their portfolio. This is the first external API integration in the app.

The project uses:
- Finnhub API for market data (60 calls/min free tier)
- DDD architecture with App facades
- Hotwire for frontend interactivity

## Goals / Non-Goals

**Goals:**
- Create `market_data` domain with App facade
- Integrate Finnhub API for symbol search and quotes
- Provide simple UI for stock lookup

**Non-Goals:**
- Caching (keep simple for now)
- Rate limiting handling (60/min is plenty)
- Historical data
- Real-time websocket updates

## Decisions

### 1. Domain Structure

```
app/domains/market_data/
├── errors.rb          # All error classes in Errors module
├── finnhub_client.rb  # API client
└── app.rb             # Facade with search_companies/get_price methods
```

Error classes namespaced under `MarketData::Errors`:
- `MarketData::Errors::ApiError`
- `MarketData::Errors::RateLimitError`
- `MarketData::Errors::AuthenticationError`

**Rationale**: Keeps errors organized in one file. Each error has a user-friendly default message.

### 2. Two Separate Methods

The domain exposes two methods with clear, product-friendly names:

```ruby
MarketData::App.search_companies("nvidia")
# => [{ symbol: "NVDA", name: "NVIDIA Corp", type: "Common Stock" }, ...]

MarketData::App.get_price("NVDA")
# => { symbol: "NVDA", price: 500.00, high: 505.00, low: 495.00, ... }
```

**Rationale**: Cleaner separation of concerns. `search_companies` finds symbols, `get_price` gets prices. Names are self-documenting without financial jargon.

### 3. Finnhub API Integration

Endpoints used:
- `GET /search?q=nvidia` — symbol search by company name
- `GET /quote?symbol=NVDA` — current price and details

API key stored in ENV (`FINNHUB_API_KEY`), loaded via `dotenv-rails`.

### 4. Controller & Routes

```ruby
# config/routes.rb
resources :stocks, only: [:index, :show]

# StocksController
def index  # search form + results (when ?q= present)
def show   # stock quote by symbol (params[:id] = symbol)
```

**Rationale**: Standard RESTful resources. Index handles searching, show displays quote.

### 5. UI Flow

1. User enters company name on `/stocks` (e.g., "nvidia")
2. Search results show symbols with **prices and change** inline
3. User can click a symbol to see detailed quote on `/stocks/NVDA`
4. Detail page shows open, high, low, previous close

Uses Turbo Frame for seamless search updates. Symbol links use `data: { turbo_frame: "_top" }` for full page navigation.

### 6. Error Handling

Three exception types under `MarketData::Errors`:
- `ApiError` — base class, generic errors (500, timeout)
- `RateLimitError` — 429 responses
- `AuthenticationError` — 401 responses

Each error has a user-friendly default message. Controller rescues base `ApiError` and uses `e.message` for flash:

```ruby
rescue MarketData::Errors::ApiError => e
  flash.now[:alert] = e.message
```

## Risks / Trade-offs

**[Risk]** API key exposed in client-side requests
→ Mitigation: All API calls server-side only, key never sent to browser

**[Risk]** Finnhub downtime breaks lookup
→ Mitigation: Acceptable for MVP; error handling shows friendly message

**[Trade-off]** No caching means repeated API calls for same stock
→ Accepted: 60/min is plenty; add caching later if needed

## Affected Domains

- `market_data` (new) — primary domain for this change
