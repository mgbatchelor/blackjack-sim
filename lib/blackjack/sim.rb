require "./lib/blackjack/game"

require_relative "./brain/automatic_decision"
require_relative "./brain/count_based_betting_strategy"
require_relative "./brain/count_based_decision"
require_relative "./brain/high_low_counting_strategy"
require_relative "./brain/simple_decision"
require_relative "./brain/simple_betting_strategy"
require_relative "./brain/random_betting_strategy"
require_relative "./brain/up_bet_when_lose"

module Blackjack

  class Sim

    def initialize(decks)
      @game = Blackjack::Game.new(decks)
    end

    def join(name, decision, betting, counting)
      player = Player.new(name, decision_strat(decision), betting_strat(betting), counting_strat(counting))
      player.set_balance(1000)
      @game.join(player)
    end

    def simulate(count)
      count.times do
        @game.start!
      end
      @game.print_stats
    end

    def decision_strat(decision)
      case decision
        when :simple
          Blackjack::Brain::SimpleDecision.new
        when :count
          Blackjack::Brain::CountBasedDecision.new
        when :auto
          Blackjack::Brain::AutomaticDecision.new
        end
    end

    def betting_strat(betting)
      case betting
        when :upbet
          Blackjack::Brain::UpBetWhenLose.new
        when :simple
          Blackjack::Brain::SimpleBettingStrategy.new
        when :random
          Blackjack::Brain::RandomBettingStrategy.new
        when :count
          Blackjack::Brain::CountBasedBettingStrategy.new
        end
    end

    def counting_strat(counting)
      case counting
        when :highlow
          Blackjack::Brain::HighLowCountingStrategy.new
        end
    end

  end
end
