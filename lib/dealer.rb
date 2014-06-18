class Dealer

  attr_reader :stats

  def initialize
    reset
  end

  def reset
    @cards = []
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
  end

  def record(result)
    @stats[:end][result] += 1
  end

  def deal_card(card)
    @stats[:showing][card.value] += 1 if @cards.empty?
    @cards << card
  end

  def to_s(show_all=false)
    cards = @cards.map(&:to_s)
    unless show_all
      cards[0] = '?'
    end
    str = "#{name} #{cards.join(',')}"
    str = "#{str} (#{value})" if show_all
    str
  end

  def showing_card
    @cards[1]
  end

  def should_hit?
    return true if value < 17
    return true if has_soft_17?
    return false
  end

  def has_21?
    value == 21
  end

  def has_soft_17?
    value == 17 && @cards.size() == 2 && (@cards[0].is_ace? || @cards[1].is_ace?)
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
