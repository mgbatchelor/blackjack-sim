require "./lib/blackjack/brain/automatic_decision"
require "./lib/blackjack/brain/manual_decision"
require "./lib/blackjack/game"

module Blackjack

  BRAIN = Blackjack::Brain::AutomaticDecision

  class Sim

    def initialize(decks)
      @game = Blackjack::Game.new(decks)
    end

    def join(name)
      @game.join(Player.new(name, Blackjack::BRAIN))
    end

    def simulate(count)
      count.times do
        @game.start!
      end
      @game.print_stats
    end

  end
end
