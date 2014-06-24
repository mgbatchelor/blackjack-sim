#!/usr/bin/env ruby

require './lib/blackjack/sim'

sim = Blackjack::Sim.new(ARGV[0].to_i)

sim.join('Michael 0', :count, :simple, :highlow)
sim.join('Michael 1', :count, :count, :highlow)
sim.join('Michael 2', :auto, :simple, :highlow)
sim.join('Michael 3', :simple, :simple, :highlow)
sim.join('Michael 4', :simple, :upbet, :highlow)

sim.simulate(ARGV[1].to_i)
