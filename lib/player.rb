require_relative './hand'

class Player

  attr_reader :cards, :name, :stats, :balance, :hand
  attr_accessor :state, :bet

  def initialize(name, brain)
    @name = name
    @brain = brain
    @hand = Hand.new(self)
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
    @balance = 0
    @bet = 0
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

  def choose_action(actions, hand, showing)
    @brain.decide(actions, hand, showing)
  end

  def to_s
    "#{balance} - #{name}"
  end


end
