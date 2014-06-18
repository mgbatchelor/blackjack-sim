#!/usr/bin/env ruby

require './lib/blackjack/sim'

sim = Blackjack::Sim.new(ARGV[0].to_i)

sim.join('Player 1')
# sim.join('Player 2')
# sim.join('Player 3')
# sim.join('Player 4')

sim.simulate(ARGV[1].to_i)
