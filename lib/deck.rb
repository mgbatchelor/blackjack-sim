require_relative './card'
require 'set'

module Suit
  CLUBS =     :club
  DIAMONDS =  :diamond
  HEARTS =    :heart
  SPADES =    :spade
end

module Value
  TWO =   { value: '2',  face_value: 2 }
  THREE = { value: '3',  face_value: 3 }
  FOUR =  { value: '4',  face_value: 4 }
  FIVE =  { value: '5',  face_value: 5 }
  SIX =   { value: '6',  face_value: 6 }
  SEVEN = { value: '7',  face_value: 7 }
  EIGHT = { value: '8',  face_value: 8 }
  NINE =  { value: '9',  face_value: 9 }
  TEN =   { value: '10', face_value: 10 }
  JACK =  { value: 'J',  face_value: 10 }
  QUEEN = { value: 'Q',  face_value: 10 }
  KING =  { value: 'K',  face_value: 10 }
  ACE =   { value: 'A',  face_value: 11 }
end


class Deck

  SUITS = [ Suit::CLUBS, Suit::DIAMONDS, Suit::HEARTS, Suit::SPADES ]
  VALUES = [ Value::TWO, Value::THREE, Value::FOUR, Value::FIVE, Value::SIX, Value::SEVEN, Value::EIGHT,
             Value::NINE, Value::TEN, Value::JACK, Value::QUEEN, Value::KING, Value::ACE ]

  def initialize(number_of_decks)
    @number_of_decks = number_of_decks
    @needs_shuffle = true
  end

  def burn_card
    next_card
    true
  end

  def next_card
    raise 'Empty deck -- needs to be shuffled' if @cards.size == 0
    @cards.shift
  end

  def needs_shuffle?
    if @needs_shuffle
      @needs_shuffle = false
      return true
    end
    @cards.count <= ((@number_of_decks * 52) / 2)
  end

  def shuffle
    @cards = build_deck.shuffle
  end

  def print_debug
    puts "Decks: #{@number_of_decks} - Cards: #{@cards.length}"
    puts @cards.each_with_object(Hash.new(0)) {|card, hash| hash[card.value] += 1}
  end

  private

    def build_deck
      cards = []
      @number_of_decks.times do
        SUITS.each do |suit|
          VALUES.each do |value|
            cards << Card.new(suit, value[:value], value[:face_value])
          end
        end
      end
      cards
    end

end
