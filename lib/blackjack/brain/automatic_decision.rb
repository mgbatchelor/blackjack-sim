module Blackjack
  module Brain
    module AutomaticDecision

      def self.decide(actions, player, showing)
        return actions.first if actions.length == 1

        if actions.include?(Blackjack::Actions::DOUBLE_DOWN)
          if (player.has_soft_ace? && should_soft_double_down?(player.value, showing.face_value)) ||
              should_double_down?(player.value, showing.face_value)
            puts "#{player.name} doubled down!"
            player.double_down
            return Blackjack::Actions::DOUBLE_DOWN
          end
        end

        if actions.include?(Blackjack::Actions::HIT)
          if (player.has_soft_ace? && should_soft_hit?(player.value, showing.face_value)) ||
              should_hit?(player.value, showing.face_value)
            puts "#{player.name} hit!"
            return Blackjack::Actions::HIT
          end
        end

        if actions.include?(Blackjack::Actions::STAND)
          return Blackjack::Actions::STAND
        end

        raise "Oops! Could not decide."
      end

      def self.should_hit?(player, showing)
        return true if player <= 11
        return true if player == 12 && (showing == 2 || showing == 3)
        return true if player < 17 && showing >= 7
        return false
      end

      def self.should_soft_hit?(player, showing)
        return true if player <= 17
        return true if player <= 18 && showing >= 9
        return false
      end

      def self.should_double_down?(player, showing)
        return true if player == 11 && showing <= 10
        return true if player == 10 && showing <= 9
        return true if player == 9 && (showing >= 3 && showing <= 6)
        return false
      end

      def self.should_soft_double_down?(player, showing)
        return true if player <= 18 && (showing == 6 && showing == 5)
        return true if player <= 18 && player >= 15 && showing == 4
        return true if player <= 18 && player >= 17 && showing == 3
        return false
      end

    end
  end
end
