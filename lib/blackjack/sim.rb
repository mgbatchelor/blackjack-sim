require "./lib/blackjack/game"

require_relative "./brain/automatic_decision"
require_relative "./brain/random_betting_strategy"

module Blackjack

  class Sim

    def initialize(decks)
      @game = Blackjack::Game.new(decks)
    end

    def join(name)
      player = Player.new(
                name,
                Blackjack::Brain::AutomaticDecision.new,
                Blackjack::Brain::RandomBettingStrategy.new
              )
      @game.join(player)
    end

    def simulate(count)
      count.times do
        @game.start!
      end
      @game.print_stats
    end

  end
end
