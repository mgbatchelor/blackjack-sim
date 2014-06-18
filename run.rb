require_relative './sim'

sim = Blackjack::Sim.new
sim.join('Michael')
sim.simulate(10000)
sim.deal!
