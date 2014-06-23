require_relative '../lib/dealer'
require_relative '../lib/card'
require_relative '../lib/deck'

def create_card(value)
  Card.new('t', value[:value], value[:face_value])
end
