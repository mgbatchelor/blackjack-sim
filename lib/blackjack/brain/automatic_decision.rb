module Blackjack
  module Brain
    module AutomaticDecision

      def self.decide(actions, player, showing)
        return actions.first if actions.length == 1

        if actions.include? Blackjack::Brain::Actions::HIT
          puts "#{player.name} - HIT"
          return Blackjack::Brain::Actions::HIT if should_hit?(player, showing)
        end

        if actions.include? Blackjack::Brain::Actions::STAND
          puts "#{player.name} - STAND"
          return Blackjack::Brain::Actions::STAND
        end

        raise "Oops! Could not decide."
      end

      def self.should_hit?(player, showing)
        return true if player.value <= 11
        return true if player.value < 17 && showing.at_least?(7)
        return false
      end

    end
  end
end
