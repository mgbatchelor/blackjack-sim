class Player

  attr_reader :cards, :name, :stats
  attr_accessor :state

  def initialize(name, brain)
    @name = name
    @brain = brain
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
    clear
  end

  def record(result)
    @stats["total"][result] += 1
    @stats["counts"]["played"] += 1
  end

  def check_for_blackjack
    @stats["counts"]["blackjack"] += 1 if @cards.size == 2 && value == 21
  end

  def deal_card(card)
    @cards << card
    puts self
    check_for_blackjack
  end

  def choose_action(actions, showing)
    @brain.decide(actions, self, showing)
  end

  def value
    @cards.inject(0) do |total, card|
      total += card.face_value(total)
    end
  end

  def to_s
    cards = @cards.map(&:to_s).join(",")
    "#{name} #{cards} (#{value})"
  end

  def set_state(state)
    puts "#{name} is #{state} with #{value}."
    @state = state
  end

  def clear
    @cards = []
    @state = nil
  end

end
