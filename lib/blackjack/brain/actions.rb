module Blackjack
  module Brain
    module Actions
      HIT =         { value: :hit, dealer_conditions: [], player_conditions: [] }
      STAND =       { value: :stand, dealer_conditions: [], player_conditions: [] }
      SPLIT =       { value: :split, dealer_conditions: [], player_conditions: [] }
      DOULBE_DOWN = { value: :double_down, dealer_conditions: [], player_conditions: [] }
      SURRENDER =   { value: :surrender, dealer_conditions: [], player_conditions: [] }
      INSURANCE =   { value: :insurance, dealer_conditions: [], player_conditions: [] }
    end
  end
end
