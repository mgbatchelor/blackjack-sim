require "./lib/blackjack/brain/actions"
require "./lib/blackjack/brain/automatic_decision"
require "./lib/blackjack/brain/manual_decision"
require "./lib/blackjack/brain/states"
require "./lib/dealer"
require "./lib/deck"
require "./lib/player"

module Blackjack

  BRAIN = Blackjack::Brain::AutomaticDecision

  class Sim

    def initialize
      @deck = Deck.new(5)
      @dealer = Dealer.new
      @players = []
      @hands = 0
    end

    def simulate(count)
      count.times do
        deal!
      end
    end

    def deck
      @deck
    end

    def join(name)
      @players << Player.new(name, Blackjack::BRAIN)
    end

    def shuffle
      @deck.shuffle
    end

    def deal!
      shuffle if @hands >= 6
      @hands += 1
      @players.each { |player| player.clear }
      @dealer.clear

      2.times do
        @players.each do |player|
          player.deal_card @deck.card
        end
        @dealer.deal_card @deck.card
      end
      show_cards
      play!
      complete!
      puts "Hand #{@hands} complete"
    end

    def play!
      @players.each do |player|
        while !(actions = get_actions(player)).empty?
          action = player.choose_action(actions, @dealer.showing_card)
          perform_action(player, action)
        end
      end

      while @dealer.should_hit?
        @dealer.deal_card @deck.card
        print_cards @dealer
      end
    end

    def complete!
      cards = @dealer.show(true).join(" | ")
      puts "#{@dealer.name} - #{cards} - #{@dealer.value}"

      @players.each do |player|
        player.record(check_hand(player))
        puts player.stats
      end
    end

    private

      def check_hand(player)
        if player.value <= 21 && (player.value > @dealer.value || @dealer.value > 21)
          puts "#{player.name} - WIN - #{player.value}"
          return :win
        elsif player.value == @dealer.value
          puts "#{player.name} - PUSH - #{player.value}"
          return :push
        else
          puts "#{player.name} - LOSE - #{player.value}"
          return :lose
        end
      end

      def show_cards
        @players.each do |player|
          print_cards player
        end
        print_cards @dealer
      end

      def print_cards(player)
        cards = player.show.join(" | ")
        puts "#{player.name} - #{cards}"
      end

      def perform_action(player, action)
        if get_actions(player).include? action
          case action
          when Blackjack::Brain::Actions::STAND
            player.state = Blackjack::Brain::States::STANDING
          when Blackjack::Brain::Actions::HIT
            player.deal_card @deck.card
            print_cards player
          end
        else
          raise "Invalid action"
        end
      end

      def get_actions(player)
        return [] if [Blackjack::Brain::States::STANDING, Blackjack::Brain::States::BUSTED].include?(player.state)
        actions = [Blackjack::Brain::Actions::STAND]
        if player.value < 21 && !@dealer.has_21?
          actions << Blackjack::Brain::Actions::HIT
        end
        actions
      end

  end
end
