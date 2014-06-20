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
      @rounds = 0
    end

    def print_stats
      puts "Dealer: #{@dealer.stats}"
      @players.each do |player|
        puts "#{player.name} #{player.stats}"
      end
    end

    def join(player)
      player.set_balance(10000)
      @players << player
    end

    def start!
      bet!
      deal!
      puts @dealer
      play!
      play_dealer!
      complete!
      puts "Hand #{@rounds} complete"
    end

    private

      def bet!
        @players.each do |player|
          player.bet!
        end
      end

      def deal!
        prep_new_deal
        2.times do
          @players.each do |player|
            hand = player.hand
            hand.deal_card @deck.next_card
          end
          @dealer.deal_card @deck.next_card
        end
      end

      def prep_new_deal
        @deck.shuffle if @rounds >= 6 || @number_of_decks == 1
        @rounds += 1
        @players.each do |player|
          hand = player.hand
          hand.clear
        end
        @dealer.clear
        @deck.burn_card
      end

      def play!
        @players.each do |player|
          puts "#{player} turn."
          hand = player.hand
          puts hand

          while !(actions = get_actions(hand)).empty?
            action = player.choose_action(actions, hand, @dealer.showing_card)
            perform_action(player, hand, action)
          end
        end
      end

      def play_dealer!
        if @dealer.has_21?
          puts "Dealer BLACKJACK!"
        else
          while @dealer.should_hit?
            @dealer.deal_card @deck.next_card
            puts @dealer.to_s(false)
          end
        end
      end

      def complete!
        puts @dealer.to_s(true)
        @dealer.record @dealer.value

        @players.each do |player|
          hand = player.hand

          player.record(check_hand(player, hand))
        end
      end

      def check_hand(player, hand)
        if hand.value <= 21
          if (hand.value > @dealer.value || @dealer.value > 21 || hand.has_blackjack?)
            if hand.has_blackjack?
              amount = 2.5 * player.bet
              puts "#{player.name} - BLACKJACK (#{amount}) - #{hand.value}"
              player.add amount
            else
              amount = 2 * player.bet
              puts "#{player.name} - WIN (#{amount}) - #{hand.value}"
              player.add amount
            end
            return :win
          elsif hand.value == @dealer.value
            puts "#{player.name} - PUSH - #{hand.value}"
            player.add player.bet
            return :push
          else ## losing hand
            puts "#{player.name} - LOSE - #{hand.value}"
            return :lose
          end
        else ## bust
          puts "#{player.name} - LOSE - #{hand.value}"
          return :lose
        end
        player.bet = 0
      end

      def perform_action(player, hand, action)
        if get_actions(hand).include? action
          case action
          when Blackjack::Actions::DOUBLE_DOWN
            player.double_down
            hand.deal_card @deck.next_card
            if hand.value > 21
              hand.set_state(Blackjack::States::BUSTED)
            else
              hand.set_state(Blackjack::States::DOUBLED_DOWN)
            end
          when Blackjack::Actions::STAND
            hand.set_state(Blackjack::States::STANDING)
          when Blackjack::Actions::HIT
            hand.deal_card @deck.next_card
            hand.set_state(Blackjack::States::BUSTED) if hand.value > 21
          end
        else
          raise "Invalid action"
        end
      end

      def get_actions(hand)
        return [] if [Blackjack::States::DOUBLED_DOWN, Blackjack::States::STANDING, Blackjack::States::BUSTED].include?(hand.state)
        actions = [Blackjack::Actions::STAND]
        if hand.card_count == 2
          actions << Blackjack::Actions::DOUBLE_DOWN
        end
        if hand.value < 21 && !@dealer.has_21?
          actions << Blackjack::Actions::HIT
        end
        actions
      end

  end
end
