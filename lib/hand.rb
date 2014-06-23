class Hand

  attr_reader :cards, :bet, :player
  attr_accessor :state

  def initialize(id, player)
    @id = id
    @player = player
    @cards = []
    @bet = 0
  end

  def name
    @player.name
  end

  def set_bet(bet)
    @bet = bet
  end

  def bet!
    @bet = @player.get_bet
  end

  def double_down!
    @bet += @player.deduct(@bet)
  end

  def split!
    puts "SPLIT ACES" if @cards.size == 2 && (@cards[0].is_ace? && @cards[1].is_ace?)

    @player.split(@cards.pop, @bet)
  end

  def split_aces?
    @state === Blackjack::States::SPLIT && @cards[0].is_ace?
  end

  def same_value?
    @cards.size == 2 && (@cards[0].face_value == @cards[1].face_value)
  end

  def has_blackjack?
    @cards.size == 2 && value == 21
  end

  def has_soft_ace?
    @cards.size == 2 && (@cards[0].is_ace? || @cards[1].is_ace?)
  end

  def set_state(state)
    puts "#{@player.name} - hand #{@id} - is #{state} with #{value}."
    @state = state
  end

  def card_count
    @cards.size
  end

  def value
    @cards.sort_by(&:card_value).each_with_index.inject(0) do |total, pair|
      card, index = pair
      last_card = index == @cards.count - 1
      total += card.face_value(total, last_card)
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
      puts "#{@player.name} - hand #{@id} - BLACKJACK!"
    end
  end

  def to_s
    cards = @cards.map(&:to_s).join(",")
    "#{@player.name} - hand #{@id} - #{cards} (#{value})"
  end

end
