module Blackjack
  module Brain
    class HighLowCountingStrategy

      attr_reader :count

      def reset(number_of_decks)
        @count = 0
        @remaining_cards = number_of_decks * 52
      end

      def count_burn
        @remaining_cards -= 1
      end

      def count_card(card)
        @remaining_cards -= 1
        if card.face_value >= 10
          @count -= 1
        elsif card.face_value <= 6
          @count += 1
        end
      end

      def true_count
        @count / (@remaining_cards / 52.to_f)
      end

    end
  end
end
