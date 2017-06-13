require './hand'
require './basic_strategy'
require './dealer_strategy'
require './bankroll'

# TODO - handle doubling and surrendering!!
class Player
  attr_reader :strategy, :split_hand, :bankroll
  def initialize(strategy, bankroll)
    @strategy = strategy
    @bankroll = bankroll
  end

  def deal_in(cards)
    @hand = Hand.new(cards)
    @split_hand = nil
    @doubled_up = false
    # TODO move to where we have count
    @bankroll.get_and_record_bet(0)
  end

  # returns the symbol of the method to do
  def get_decision(dealer_show_card)
    dealer_show_value = dealer_show_card.value
    @strategy.play(@hand, dealer_show_value)
  end

  def busted?
    @hand.busted?
  end

  def value(include_soft = false)
    @hand.value(include_soft)
  end

  def hit(card)
    @hand.hit(card)
  end

  def blackjack?
    @hand.blackjack?
  end

  def split
    # representing the doubled hand as a player with the same strategy, bit hacky
    @split_hand = Player.new(BasicStrategy, Bankroll.new(0))
    @split_hand.deal_in([@hand.first_card])
    @hand = Hand.new([@hand.second_card])
  end

  def double_up
    @doubled_up = true
  end

  def split?
    !@split_hand.nil?
  end

  def doubled?
    @doubled_up
  end
end
