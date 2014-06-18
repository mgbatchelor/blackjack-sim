module Blackjack
  module Brain
    module ManualDecision

      def self.decide(actions, player, showing)
        actions.each_with_index do |action, index|
          puts "#{index}) #{action[:value]}"
        end
        print "#{name} >> "
        index = gets.chomp
        actions[index.to_i]
      end

    end

  end
end
