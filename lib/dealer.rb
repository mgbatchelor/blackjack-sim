class Dealer

  attr_reader :stats

  def initialize
    @cards = []
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
  end

  def name
    'Dealer'
  end

  def record(result)
    @stats[:end][result] += 1
  end

  def deal_card(card)
    @stats[:showing][card.value] += 1 if @cards.size == 1
    @cards << card
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
    @cards.sort_by(&:card_value).each_with_index.inject(0) do |total, pair|
      card, index = pair
      last_card = index == @cards.count - 1
      total += card.face_value(total, last_card)
    end
  end

  def clear
    @cards = []
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

  def print_stats
    puts '--------------------'
    puts '--- Dealer stats ---'
    puts '--------------------'
    puts '------ showing -----'
    showing = @stats[:showing].to_a.sort_by(&:last)
    total = showing.map(&:last).reduce{|t,v| t+= v}
    showing.each do |stat|
      card_ratio = 100 * stat.last / total.to_f
      puts " >>  #{stat.first}  >> #{card_ratio}%"
    end

    puts '------ totals ------'
    final_values = @stats[:end]
    total = final_values.values.reduce{|t,v| t+= v}
    final_values.reject{|k,v| k > 21}.sort.each do |stat|
      card_ratio = 100 * stat.last / total.to_f
      puts " >>  #{stat.first}  >> #{card_ratio}%"
    end
    bust_hands = final_values.select{|k,v| k > 21}.values.inject(0){ |v,t| t += v }
    bust_ratio = 100 * bust_hands / total.to_f
    puts " >> Bust >> #{bust_ratio}%"
  end

end
