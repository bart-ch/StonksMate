module MarketData
  module Errors
    class ApiError < StandardError
      def initialize(message = "Unable to fetch stock data. Please try again.")
        super
      end
    end

    class RateLimitError < ApiError
      def initialize(message = "API rate limit exceeded. Please try again later.")
        super
      end
    end

    class AuthenticationError < ApiError
      def initialize(message = "Service configuration error. Please contact support.")
        super
      end
    end
  end
end
