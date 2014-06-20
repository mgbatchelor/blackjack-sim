#!/usr/bin/env ruby

require './lib/blackjack/sim'

sim = Blackjack::Sim.new(ARGV[0].to_i)

sim.join('Michael')
sim.join('Nikki')
sim.join('Chloe')
sim.join('Jacob')

sim.simulate(ARGV[1].to_i)
