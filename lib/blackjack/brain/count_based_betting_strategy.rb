module Blackjack
  module Brain
    class CountBasedBettingStrategy

      def calculate_bet(data)
        true_count = data[:true_count]
        if true_count <= 2
          10
        elsif true_count <= 10
          50
        elsif true_count <= 20
          75
        else
          100
        end
      end

    end
  end
end
