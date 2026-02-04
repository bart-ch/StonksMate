## Why

Users need to look up stock information before adding to their portfolio. This provides a quick way to check current prices and find stocks by name or symbol. It's the foundation for the portfolio feature.

## What Changes

- Add unified stock lookup: enter symbol OR company name, get price
- If input is a symbol → direct quote
- If input is a name → search, then show matches with prices
- Establish the market_data domain with App facade
- Integrate a free market data API (Finnhub or similar)

## Capabilities

### New Capabilities

- `stock-lookup`: Unified lookup by symbol or company name, returns price and info
- `market-data-domain`: App facade for market data operations

### Modified Capabilities

(none)

## Non-goals

- Historical price data (add later)
- Real-time streaming prices (add later)
- Caching/rate limiting (keep simple for now)
- Saving favorite stocks (belongs in portfolio feature)

## Impact

- `app/domains/market_data/` — new domain with App facade and API client
- `app/controllers/stocks_controller.rb` — endpoints for quote and search
- `app/views/stocks/` — simple UI for lookup
- `config/routes.rb` — stock routes
