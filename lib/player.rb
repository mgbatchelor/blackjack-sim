class Player

  attr_reader :cards, :name, :stats, :balance
  attr_accessor :state, :bet

  def initialize(name, brain)
    @name = name
    @brain = brain
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
    @balance = 0
    @bet = 0
    clear
  end

  def bet!
    bet = 10
    puts "#{name} bet #{bet}"
    @bet = deduct(bet)
  end

  def set_balance(amount)
    @balance = amount
  end

  def add(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
    amount
  end

  def double_down
    @bet += deduct(@bet)
  end

  def record(result)
    @stats["total"][result] += 1
    @stats["counts"]["played"] += 1
  end

  def has_blackjack?
    @cards.size == 2 && value == 21
  end

  def has_soft_ace?
    @cards.size == 2 && (@cards[0].is_ace? || @cards[1].is_ace?)
  end

  def check_for_blackjack
    if has_blackjack?
      @stats["counts"]["blackjack"] += 1
      puts "#{name} BLACKJACK!"
    end
  end

  def deal_card(card)
    @cards << card
    puts self
    check_for_blackjack
  end

  def choose_action(actions, showing)
    @brain.decide(actions, self, showing)
  end

  def card_count
    @cards.size
  end

  def value
    @cards.inject(0) do |total, card|
      total += card.face_value(total)
    end
  end

  def to_s
    cards = @cards.map(&:to_s).join(",")
    "#{balance} #{name} #{cards} (#{value})"
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
