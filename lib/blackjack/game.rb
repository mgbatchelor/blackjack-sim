require_relative "./actions"
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
      @dealer.print_stats
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
          player.clear_hands
          player.hands.each do |hand|
            hand.bet!
          end
        end
      end

      def deal!
        prep_new_deal
        2.times do
          @players.each do |player|
            player.hands.each do |hand|
              hand.deal_card @deck.next_card
            end
          end
          @dealer.deal_card @deck.next_card
        end
      end

      def prep_new_deal
        @deck.shuffle if @rounds >= 6 || @number_of_decks == 1
        @rounds += 1
        @players.each do |player|
          player.hands.each do |hand|
            hand.clear
          end
        end
        @dealer.clear
        @deck.burn_card
      end

      def play!
        @players.each do |player|
          puts "#{player} turn."
          player.hands.each do |hand|
            puts hand
            while !(actions = get_actions(player, hand)).empty?
              action = player.choose_action(actions, hand, @dealer.showing_card)
              perform_action(player, hand, action)
            end
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
          player.hands.each do |hand|
            player.record(check_hand(player, hand))
          end
        end
      end

      def check_hand(player, hand)
        if hand.value <= 21
          if (hand.value > @dealer.value || @dealer.value > 21 || hand.has_blackjack?)
            if hand.has_blackjack?
              amount = 2.5 * hand.bet
              puts "*BLACKJACK* #{hand} - #{amount}"
              player.add amount
            else
              amount = 2 * hand.bet
              puts "*WON* #{hand} - #{amount}"
              player.add amount
            end
            return :win
          elsif hand.value == @dealer.value
            puts "*PUSHED* #{hand}"
            player.add hand.bet
            return :push
          else ## losing hand
            puts "*LOST* #{hand}"
            return :lose
          end
        else ## bust
          puts "*LOST* #{hand}"
          return :lose
        end
      end

      def perform_action(player, hand, action)
        if get_actions(player, hand).include? action
          case action
          when Blackjack::Actions::DOUBLE_DOWN
            hand.double_down!
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
          when Blackjack::Actions::SPLIT
            hand.split!
            puts hand.player.hands
            hand.player.hands.each do |split_hand|
              split_hand.set_state(Blackjack::States::SPLIT)
              split_hand.deal_card @deck.next_card if split_hand.card_count == 1
              split_hand.set_state(Blackjack::States::STANDING) if split_hand.split_aces?
            end
          else
            raise "Invalid action"
          end
        else
          raise "Invalid action"
        end
      end

      def get_actions(player, hand)
        return [] if [Blackjack::States::DOUBLED_DOWN, Blackjack::States::STANDING, Blackjack::States::BUSTED].include?(hand.state)
        actions = [Blackjack::Actions::STAND]
        if hand.card_count == 2
          actions << Blackjack::Actions::DOUBLE_DOWN
        end
        if hand.same_value? && player.number_of_hands < 4
          actions << Blackjack::Actions::SPLIT
        end
        if hand.value < 21 && !@dealer.has_21?
          actions << Blackjack::Actions::HIT
        end
        actions
      end

  end
end
