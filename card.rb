class Card
  def initialize(number)
    @number = number
  end

  def value(options = {})
    if @number >= 2 && @number <= 10
      @number
    elsif @number > 10
      10
    else
      # aces
      options[:soft] ? 1 : 11
    end
  end

  def is_ace?
    @number == 1
  end
end
