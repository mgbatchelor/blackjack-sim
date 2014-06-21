require_relative './hand'

class Player

  attr_reader :cards, :name, :stats, :balance, :hands
  attr_accessor :state

  def initialize(name, brain, betting_strategy)
    @name = name
    @brain = brain
    @betting_strategy = betting_strategy
    @hands = []
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
    @balance = 0
  end

  def get_bet
    bet = @betting_strategy.calculate_bet
    puts "#{name} bet #{bet}"
    deduct(bet)
  end

  def split(card, bet)
    hand = Hand.new(@hands.size + 1, self)
    hand.set_bet deduct(bet)
    hand.deal_card card
    @hands << hand
  end

  def set_balance(amount)
    @balance = amount
  end

  def add(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
    return amount
  end

  def record(result)
    @stats["total"][result] += 1
    @stats["counts"]["played"] += 1
  end

  def choose_action(actions, hand, showing)
    @brain.decide(actions, hand, showing)
  end

  def number_of_hands
    @hands.size
  end

  def clear_hands
    @hands = [ Hand.new(1, self) ]
  end

  def to_s
    "#{balance} - #{name}"
  end

  def print_stats
    puts "#{name} >> #{balance} <<"
    total = @stats["counts"]["played"]
    @stats["total"].each do |key, stat|
      percent = 100 * (stat / total.to_f)
      puts ">> #{key} >> #{percent}%"
    end
  end

end
