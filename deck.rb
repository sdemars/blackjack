require './card'

class Deck
  attr_accessor :count

  DECK_SIZE = 52
  TOO_LOW_NUMBER = 26

  def initialize
    @cards = []
    4.times do
      (1..13).each do |num|
        @cards << Card.new(num)
      end
    end
    # start shuffled
    self.shuffle
  end

  def deal
    raise "Out of Cards" if @index >= DECK_SIZE - 1

    card = @cards[@index]

    if card.value <= 6
      @count += 1
    elsif card.value >= 10
      @count -= 1
    end

    @index += 1
    card
  end

  def shuffle
    (DECK_SIZE-1).downto(1).each do |num|
      # shuffle algorithm swap them
      j = rand(num)
      temp = @cards[j]
      @cards[j] = @cards[num]
      @cards[num] = temp
    end

    # reset "top of deck"
    @index = 0
    # reset card count
    @count = 0
  end

  def running_low?
    DECK_SIZE - @index <= TOO_LOW_NUMBER
  end
end
