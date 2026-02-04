class StocksController < ApplicationController
  def index
    @query = params[:q]
    @results = []

    if @query.present?
      search_results = MarketData::App.search_companies(@query)
      @no_results = search_results.empty?

      @results = search_results.first(10).map do |stock|
        quote = MarketData::App.get_price(stock[:symbol])
        stock.merge(price: quote[:price], change: quote[:change], change_percent: quote[:change_percent])
      rescue MarketData::Errors::ApiError
        stock.merge(price: nil, change: nil, change_percent: nil)
      end
    end
  rescue MarketData::Errors::ApiError => e
    flash.now[:alert] = e.message
  end

  def show
    @symbol = params[:id].upcase
    @stock = MarketData::App.get_price(@symbol)

    if @stock[:price].nil? || @stock[:price].zero?
      flash[:alert] = "Stock not found: #{@symbol}"
      redirect_to stocks_path
    end
  rescue MarketData::Errors::ApiError => e
    flash[:alert] = e.message
    redirect_to stocks_path
  end
end
