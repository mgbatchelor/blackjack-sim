require 'spec_helper'

describe Dealer do

  let(:dealer) { Dealer.new}

  it 'should the dealer with no cards' do
    expect(dealer.value).to eq(0)
  end

  it 'should add the cards value to the dealers hand' do
    dealer.deal_card(create_card(Value::TEN))
    expect(dealer.value).to eq(10)
    dealer.deal_card(create_card(Value::TWO))
    expect(dealer.value).to eq(12)
    dealer.deal_card(create_card(Value::FOUR))
    expect(dealer.value).to eq(16)
    dealer.deal_card(create_card(Value::FIVE))
    expect(dealer.value).to eq(21)
  end

  it 'calculates aces correctly' do
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.value).to eq(11)
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.value).to eq(12)
    dealer.deal_card(create_card(Value::KING))
    expect(dealer.value).to eq(12)
    dealer.deal_card(create_card(Value::SIX))
    expect(dealer.value).to eq(18)
  end

  it 'calculates blackjacks' do
    dealer.deal_card(create_card(Value::KING))
    expect(dealer.value).to eq(10)
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.value).to eq(21)
    expect(dealer.has_21?).to eq(true)
    dealer.clear
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.value).to eq(11)
    dealer.deal_card(create_card(Value::TEN))
    expect(dealer.value).to eq(21)
    expect(dealer.has_21?).to eq(true)
  end

  it 'should hit when needs another card' do
    expect(dealer.should_hit?).to eq(true)
    dealer.deal_card(create_card(Value::KING))
    expect(dealer.should_hit?).to eq(true)
    dealer.deal_card(create_card(Value::THREE))
    expect(dealer.should_hit?).to eq(true)
    dealer.deal_card(create_card(Value::THREE))
    expect(dealer.should_hit?).to eq(true)
    expect(dealer.value).to eq(16)
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.should_hit?).to eq(false)
    expect(dealer.value).to eq(17)
  end

  it 'should hit when has soft 17' do
    dealer.deal_card(create_card(Value::ACE))
    dealer.deal_card(create_card(Value::SIX))
    expect(dealer.has_soft_17?).to eq(true)
    expect(dealer.should_hit?).to eq(true)

    dealer.clear
    dealer.deal_card(create_card(Value::SIX))
    dealer.deal_card(create_card(Value::ACE))
    expect(dealer.has_soft_17?).to eq(true)
    expect(dealer.should_hit?).to eq(true)
  end

end
