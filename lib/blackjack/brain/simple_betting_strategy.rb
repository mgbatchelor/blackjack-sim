module Blackjack
  module Brain
    class SimpleBettingStrategy

      def initialize
        @bets = [10, 20, 30, 40, 50, 100]
      end

      def calculate_bet
        @bets[rand(@bets.size - 1)]
      end

    end
  end
end
