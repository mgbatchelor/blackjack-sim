class Player

  attr_reader :cards, :name, :stats
  attr_accessor :state

  def initialize(name, brain)
    @name = name
    @brain = brain
    @stats = Hash.new(0)
    @games_played = 0
    clear
  end

  def record(result)
    @stats[result] += 1
    @games_played += 1
  end

  def deal_card(card)
    @cards << card
  end

  def choose_action(actions, showing)
    @brain.decide(actions, self, showing)
  end

  def value
    @cards.inject(0) do |total, card|
      total += card.face_value(total)
    end
  end

  def show
    @cards.map(&:to_s)
  end

  def clear
    @cards = []
    @state = nil
  end

end
