class Hand

  attr_reader :cards
  attr_accessor :state

  def initialize(player)
    @player = player
  end

  def name
    @player.name
  end

  def has_blackjack?
    @cards.size == 2 && value == 21
  end

  def has_soft_ace?
    @cards.size == 2 && (@cards[0].is_ace? || @cards[1].is_ace?)
  end

  def set_state(state)
    puts "#{@player.name} is #{state} with #{value}."
    @state = state
  end

  def card_count
    @cards.size
  end

  def value
    @cards.inject(0) do |total, card|
      total += card.face_value(total)
    end
  end

  def deal_card(card)
    @cards << card
    puts self
    check_for_blackjack
  end

  def clear
    @cards = []
    @state = nil
  end

  def check_for_blackjack
    if has_blackjack?
      @player.stats["counts"]["blackjack"] += 1
      puts "#{@player.name} BLACKJACK!"
    end
  end

  def to_s
    cards = @cards.map(&:to_s).join(",")
    "#{@player.name} > #{cards} (#{value})"
  end

end
