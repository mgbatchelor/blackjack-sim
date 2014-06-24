module Blackjack
  module Brain
    class CountBasedDecision < Blackjack::Brain::AutomaticDecision

      def decide(actions, hand, showing, opts={})
        @true_count = opts[:true_count]
        super(actions, hand, showing, opts)
      end

      def should_hit?(hand, showing)
        return false if hand == 16 && showing == 10 && @true_count >= 0
        return false if hand == 15 && showing == 10 && @true_count >= 4
        return false if hand == 12 && showing == 3 && @true_count >= 2
        return false if hand == 12 && showing == 2 && @true_count >= 3
        return false if hand == 16 && showing == 9 && @true_count >= 5
        return false if hand == 13 && showing == 2 && @true_count >= -1
        return false if hand == 12 && showing == 4 && @true_count >= 0
        return false if hand == 12 && showing == 5 && @true_count >= -2
        return false if hand == 12 && showing == 6 && @true_count >= -1
        return false if hand == 13 && showing == 3 && @true_count >= -2
        return super(hand, showing)
      end

      def should_soft_hit?(hand, showing)
        return super(hand, showing)
      end

      def should_double_down?(hand, showing)
        return true if hand == 10 && showing == 10 && @true_count >= 4
        return true if hand == 11 && showing == 11 && @true_count >= 1
        return true if hand == 9 && showing == 2 && @true_count >= 1
        return true if hand == 10 && showing == 11 && @true_count >= 4
        return true if hand == 9 && showing == 7 && @true_count >= 3
        return false
      end

      def should_soft_double_down?(hand, showing)
        return super(hand, showing)
      end

      def should_split?(split_card, showing)
        return true if split_card.face_value == 10 && showing == 5 && @true_count >= 5
        return true if split_card.face_value == 10 && showing == 6 && @true_count >= 4
        return false
      end

    end
  end
end
