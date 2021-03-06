require './card'

class Hand
  def initialize(cards)
    @cards = cards
  end

  def hit(card)
    @cards << card
  end

  def first_card
    @cards[0]
  end

  def second_card
    @cards[1]
  end

  # returns sum, soft - boolean as to whether it is a soft sum
  def value(include_soft = false)
    val = @cards.map(&:value).inject(:+)

    aces = @cards.select(&:is_ace?)
    while val > 21 && !aces.empty?
      ace = aces.pop
      # Could hardcode to -10
      val -= ace.value
      val += ace.value(soft: true)
    end

    if include_soft
      [val, !aces.empty?]
    else
      val
    end
  end

  def busted?
    value > 21
  end

  def doubles?
    # Yes this will count jack, queen as a double but it doesn't
    # matter for basic strategy so whatever
    @cards.length == 2 && @cards[0].value == @cards[1].value
  end

  def blackjack?
    @cards.length == 2 && value == 21
  end
end
