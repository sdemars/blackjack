require './card'

class Deck
  DECK_SIZE = 52
  TOO_LOW_NUMBER = 25

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

    @index += 1
    @cards[@index - 1]
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
  end

  def running_low?
    DECK_SIZE - @index <= TOO_LOW_NUMBER
  end
end
