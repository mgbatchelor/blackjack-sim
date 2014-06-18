require_relative "./actions"
require_relative "./brain/automatic_decision"
require_relative "./brain/manual_decision"
require_relative "./states"
require_relative "../dealer"
require_relative "../deck"
require_relative "../player"

module Blackjack

  class Game

    def initialize(number_of_decks)
      @number_of_decks = number_of_decks
      @deck = Deck.new(@number_of_decks)
      @dealer = Dealer.new
      @players = []
      @hands = 0
    end

    def print_stats
      puts "Dealer: #{@dealer.stats}"
      @players.each do |player|
        puts "#{player.name} #{player.stats}"
      end
    end

    def join(player)
      @players << player
    end

    def deal!
      prep_new_deal
      2.times do
        @players.each do |player|
          player.deal_card @deck.next_card
        end
        @dealer.deal_card @deck.next_card
      end
      puts @dealer
      play!
      play_dealer!
      complete!
      puts "Hand #{@hands} complete"
    end

    private

      def prep_new_deal
        @deck.shuffle if @hands >= 6 || @number_of_decks == 1
        @hands += 1
        @players.each { |player| player.clear }
        @dealer.clear
        @deck.burn_card
      end

      def play!
        @players.each do |player|
          puts "#{player.name} turn."
          puts player
          while !(actions = get_actions(player)).empty?
            action = player.choose_action(actions, @dealer.showing_card)
            perform_action(player, action)
          end
        end
      end

      def play_dealer!
        while @dealer.should_hit?
          @dealer.deal_card @deck.next_card
          puts @dealer.to_s(false)
        end
      end

      def complete!
        puts @dealer.to_s(true)
        @dealer.record @dealer.value

        @players.each do |player|
          player.record(check_hand(player))
        end
      end

      def check_hand(player)
        if player.value <= 21
          if (player.value > @dealer.value || @dealer.value > 21)
            puts "#{player.name} - WIN - #{player.value}"
            return :win
          elsif player.value == @dealer.value
            puts "#{player.name} - PUSH - #{player.value}"
            return :push
          else ## losing hand
            puts "#{player.name} - LOSE - #{player.value}"
            return :lose
          end
        else ## bust
          puts "#{player.name} - LOSE - #{player.value}"
          return :lose
        end
      end

      def perform_action(player, action)
        if get_actions(player).include? action
          case action
          when Blackjack::Actions::STAND
            player.set_state(Blackjack::States::STANDING)
          when Blackjack::Actions::HIT
            player.deal_card @deck.next_card
            player.set_state(Blackjack::States::BUSTED) if player.value > 21
          end
        else
          raise "Invalid action"
        end
      end

      def get_actions(player)
        return [] if [Blackjack::States::STANDING, Blackjack::States::BUSTED].include?(player.state)
        actions = [Blackjack::Actions::STAND]
        if player.value < 21 && !@dealer.has_21?
          actions << Blackjack::Actions::HIT
        end
        actions
      end

  end
end
