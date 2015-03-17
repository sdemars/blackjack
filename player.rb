require './hand'
require './basic_strategy'

# TODO - handle doubling and surrendering!!
class Player
  attr_reader :strategy, :split_hand
  def initialize(strategy)
    @strategy = strategy
  end

  def deal_in(cards)
    @hand = Hand.new(cards)
    @split_hand = nil
    @doubled_up = false
  end

  # returns the symbol of the method to do
  def get_decision(dealer_show_card)
    dealer_show_value = dealer_show_card.value
    if @strategy == :basic
      play_with_basic_strategy(dealer_show_value)
    elsif @strategy == :dealer
      play_with_dealer_strategy
    else
      raise "Unrecognized strategy"
    end
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
    @split_hand = Player.new(@strategy)
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

  def play_with_dealer_strategy
    # assuming a dealer HITS on soft 17
    value, soft = @hand.value(true)
    if value > 17 || (value == 17 && !soft)
      :stand
    else
      :hit
    end
  end

  # single deck basic strategy, source at:
  # http://wizardofodds.com/games/blackjack/strategy/1-deck/
  def play_with_basic_strategy(dealer_show_value)
    BasicStrategy.play(@hand, dealer_show_value)
  end
end
