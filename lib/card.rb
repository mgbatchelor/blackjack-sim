require 'securerandom'

class Card

  attr_accessor :suit, :value, :id

  def initialize(suit, value, face_value)
    @id = SecureRandom.uuid
    @suit = suit
    @value = value
    @face_value = face_value
  end

  def is_ace?
    @value == 'A'
  end

  def at_least?(value)
    @face_value >= value
  end

  def face_value(hand_value)
    return (hand_value + @face_value > 21) ? 1 : @face_value if is_ace?
    return @face_value
  end

  def to_s
    "#{@value} #{@suit}"
  end

end