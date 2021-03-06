module Blackjack
  module Brain
    class ManualDecision

      def decide(actions, player, showing, opts={})
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
