class Dealer

  def initialize
    reset
  end

  def reset
    @cards = []
  end

  def deal_card(card)
    @cards << card
  end

  def show(show_all=false)
    cards = @cards.map(&:to_s)
    cards[0] = '?' unless show_all
    cards
  end

  def showing_card
    @cards[1]
  end

  def should_hit?
    value < 17
  end

  def has_21?
    value == 21
  end

  def value
    @cards.inject(0) do |total, card|
      total += card.face_value(total)
    end
  end

  def name
    'Dealer'
  end

  def clear
    @cards = []
  end

end
