require_relative './hand'

class Player

  attr_reader :cards, :name, :stats, :balance, :hands
  attr_accessor :state

  def initialize(name, brain, betting_strategy, counting_strategy)
    @name = name
    @brain = brain
    @betting_strategy = betting_strategy
    @counting_strategy = counting_strategy
    @hands = []
    @stats = Hash.new() { |hash, key| hash[key] = Hash.new(0) }
    @balance = 0
    @last_hand_result = 0
  end

  def card_burned
    @counting_strategy.count_burn
  end

  def card_dealt(card)
    @counting_strategy.count_card card
  end

  def deck_shuffled(number_of_decks)
    @counting_strategy.reset(number_of_decks)
  end

  def get_bet
    bet = @betting_strategy.calculate_bet({last_hand_result: @last_hand_result, true_count: @counting_strategy.true_count})
    @last_hand_result = 0
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
    @initial_balance = amount
    @stats["counts"]["lowest"] = amount
    @balance = amount
  end

  def add(amount)
    @last_hand_result += amount
    @balance += amount
  end

  def deduct(amount)
    @last_hand_result -= amount
    @balance -= amount
    return amount
  end

  def record(result)
    @stats["total"][result] += 1
    @stats["counts"]["played"] += 1
    @stats["counts"]["lowest"] = @balance if @balance < @stats["counts"]["lowest"]
    @stats["counts"]["highest"] = @balance if @balance > @stats["counts"]["highest"]
  end

  def choose_action(actions, hand, showing)
    @brain.decide(actions, hand, showing, { true_count: @counting_strategy.true_count })
  end

  def number_of_hands
    @hands.size
  end

  def clear_hands
    @hands = [ Hand.new(1, self) ]
  end

  def to_s
    "COUNT:#{@counting_strategy.true_count} #{balance} - #{name}"
  end

  def print_stats
    puts "#{name} >> #{balance} <<"
    gain = @balance - @initial_balance
    gain_percent = 100 * (gain / @initial_balance.to_f)
    puts "Gain #{gain} -- %#{gain_percent}"
    total = @stats["counts"]["played"]
    highest = @stats["counts"]["highest"]
    lowest = @stats["counts"]["lowest"]
    puts "Highest #{highest} - Lowest = #{lowest}"
    @stats["total"].each do |key, stat|
      percent = 100 * (stat / total.to_f)
      puts ">> #{key} >> #{percent}%"
    end
  end

end
