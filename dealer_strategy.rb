class DealerStrategy
	# Dealer stands on soft 17
  STAND_17 = false

  def self.play(hand, dealer_show_value)
    value, soft = hand.value(true)
    if value > 17 || STAND_17 || (value == 17 && !soft)
      :stand
    else
      :hit
    end
  end
end