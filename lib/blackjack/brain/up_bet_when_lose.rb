module Blackjack
  module Brain
    class UpBetWhenLose

      def initialize
        @last_bet = 10
        @max_bet = @last_bet * 6 
      end

      def calculate_bet(last_hand_result)
        if last_hand_result > 0
          @last_bet = 10
          @last_bet
        else
          @last_bet = @last_bet * 2 if @last_bet <= @max_bet
          @last_bet
        end
      end

    end
  end
end
