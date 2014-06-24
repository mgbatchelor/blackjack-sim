module Blackjack
  module Brain
    class RandomBettingStrategy

      def initialize
        @bets = [10, 20, 30, 40, 50, 100, 500]
      end

      def calculate_bet(data)
        @bets[rand(@bets.size - 1)]
      end

    end
  end
end
