require './hand'

# TODO - handle doubling and surrendering!!
class Player
  attr_reader :strategy, :doubled_hand
  def initialize(strategy)
    @strategy = strategy
  end

  def deal_in(cards)
    @hand = Hand.new(cards)
    @doubled_hand = nil
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

  def double
    # representing the doubled hand as a player with the same strategy
    @doubled_hand = Player.new(@strategy)
    @doubled_hand.deal_in([@hand[0]])
    @hand = [@hand[1]]
  end

  def doubled?
    !@doubled_hand.nil?
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

  def play_with_basic_strategy(dealer_show_value)
    return play_with_dealer_strategy
    val, soft = value(true)

    if val <= 8
      return :hit
    elsif val == 9
      if dealer_show_value >= 3 && dealer_show_value <= 6
        :double
      else
        :hit
      end
    elsif val == 10
      if dealer_show_value <= 9
        :double
      else
        :hit
      end
    elsif val == 11

    elsif val == 12

    elsif val == 13

    elsif val == 14

    elsif val == 15

    elsif val == 16

    elsif val == 17

    elsif val == 18

    elsif val == 19 && soft

    else
      :stand
    end
  end
end
