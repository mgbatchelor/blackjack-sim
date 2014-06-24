module Blackjack
  module Brain
    class SimpleDecision

      def decide(actions, hand, showing, opts={})
        return actions.first if actions.length == 1

        if actions.include?(Blackjack::Actions::HIT)
          if should_hit?(hand.value, showing.face_value)
            return Blackjack::Actions::HIT
          end
        end

        if actions.include?(Blackjack::Actions::STAND)
          return Blackjack::Actions::STAND
        end

        raise "Oops! Could not decide."
      end

      def should_hit?(hand, showing)
        return true if hand < 17 #&& showing >= 7
        return false
      end

    end
  end
end
