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

  def card_value
    @face_value
  end

  def face_value(hand_value = 0, last_card = false)
    if is_ace?
      if !last_card && (hand_value + @face_value) == 21
        return 1
      elsif (hand_value + @face_value) > 21
        return 1
      else
        @face_value
      end
    end
    return @face_value
  end

  def to_s
    "#{@value}#{@suit[0]}"
  end

end
