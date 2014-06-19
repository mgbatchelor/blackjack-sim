module Blackjack
  module Brain
    module AutomaticDecision

      def self.decide(actions, player, showing)
        return actions.first if actions.length == 1

        if actions.include? Blackjack::Actions::DOUBLE_DOWN

          if should_double_down?(player, showing)
            puts "#{player.name} doubled down!"
            player.double_down
            return Blackjack::Actions::DOUBLE_DOWN
          end

        end

        if actions.include? Blackjack::Actions::HIT

          if should_hit?(player, showing)
            puts "#{player.name} hit!"
            return Blackjack::Actions::HIT
          end

        end

        if actions.include? Blackjack::Actions::STAND
          return Blackjack::Actions::STAND
        end

        raise "Oops! Could not decide."
      end

      def self.should_hit?(player, showing)
        return true if player.value <= 11
        return true if player.value < 17 && showing.card_value >= 7
        return false
      end

      def self.should_double_down?(player, showing)
        return true if (player.value >= 6 && player.value <= 11) && (showing.card_value == 5 || showing.card_value == 6)
      end
    end
  end
end
