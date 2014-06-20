module Blackjack
  module Brain
    module AutomaticDecision

      def self.decide(actions, hand, showing)
        return actions.first if actions.length == 1

        if actions.include?(Blackjack::Actions::SPLIT)
          if should_split?(hand.cards.first, showing.face_value)
            return Blackjack::Actions::SPLIT
          end
        end

        if actions.include?(Blackjack::Actions::DOUBLE_DOWN)
          if (hand.has_soft_ace? && should_soft_double_down?(hand.value, showing.face_value)) ||
              should_double_down?(hand.value, showing.face_value)
            return Blackjack::Actions::DOUBLE_DOWN
          end
        end

        if actions.include?(Blackjack::Actions::HIT)
          if (hand.has_soft_ace? && should_soft_hit?(hand.value, showing.face_value)) ||
              should_hit?(hand.value, showing.face_value)
            return Blackjack::Actions::HIT
          end
        end

        if actions.include?(Blackjack::Actions::STAND)
          return Blackjack::Actions::STAND
        end

        raise "Oops! Could not decide."
      end

      def self.should_hit?(hand, showing)
        return true if hand <= 11
        return true if hand == 12 && (showing == 2 || showing == 3)
        return true if hand < 17 && showing >= 7
        return false
      end

      def self.should_soft_hit?(hand, showing)
        return true if hand <= 17
        return true if hand <= 18 && showing >= 9
        return false
      end

      def self.should_double_down?(hand, showing)
        return true if hand == 11 && showing <= 10
        return true if hand == 10 && showing <= 9
        return true if hand == 9 && (showing >= 3 && showing <= 6)
        return false
      end

      def self.should_soft_double_down?(hand, showing)
        return true if hand <= 18 && (showing == 6 || showing == 5)
        return true if hand <= 18 && hand >= 15 && showing == 4
        return true if hand <= 18 && hand >= 17 && showing == 3
        return false
      end

      def self.should_split?(split_card, showing)
        return true if split_card.is_ace?
        return true if split_card.face_value == 9 && showing <= 9 && showing != 7
        return true if split_card.face_value == 8
        return true if split_card.face_value == 7 && showing <= 7
        return true if split_card.face_value == 6 && showing <= 6
        return true if split_card.face_value == 4 && (showing == 5 || showing == 6)
        return true if split_card.face_value == 3 && showing <= 7
        return true if split_card.face_value == 2 && showing <= 7
        return false
      end

    end
  end
end
