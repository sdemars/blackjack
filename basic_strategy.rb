class BasicStrategy
  # property of the table / casino
  ALLOW_DOUBLE_AFTER_SPLIT = false

  # single deck basic strategy, source at:
  # http://wizardofodds.com/games/blackjack/strategy/1-deck/
  def self.play(hand, dealer_show_value)
    val, soft = hand.value(true)

    if hand.doubles?
      play_doubles(val, soft, dealer_show_value)
    elsif val < 13
      play_low_cards(val, dealer_show_value)
    elsif soft
      play_soft(val, dealer_show_value)
    else
      play_hard(val, dealer_show_value)
    end
  end

  def self.play_low_cards(val, dealer_show_value)
    if val <= 7
      :hit
    elsif val == 8
      if (5..6).include?(dealer_show_value)
        :double
      else
        :hit
      end
    elsif val == 9
      if dealer_show_value <= 6
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
      :double
    elsif val == 12
      if (4..6).include?(dealer_show_value)
        :stand
      else
        :hit
      end
    end
  end

  def self.play_soft(val, dealer_show_value)
    if (13..16).include?(val)
      if (4..6).include?(dealer_show_value)
        :double
      else
        :hit
      end
    elsif val == 17
      if dealer_show_value <= 6
        :double
      else
        :hit
      end
    elsif val == 18
      if (3..6).include?(dealer_show_value)
        :double
      else
        :stand
      end
    elsif val == 19
      if dealer_show_value == 6
        :double
      else
        :stand
      end
    else
      :stand
    end
  end

  def self.play_hard(val, dealer_show_value)
    if val == 16
      if dealer_show_value >= 10
        :surrender
      else
        :stand
      end
    elsif (13..15).include?(val)
      if dealer_show_value <= 6
        :stand
      else
        :hit
      end
    else
      :stand
    end
  end

  def self.play_doubles(val, soft, dealer_show_value)
    if val == 4
      if dealer_show_value == 2 && !ALLOW_DOUBLE_AFTER_SPLIT
        :hit
      elsif dealer_show_value <= 7
        :split
      else
        :hit
      end
    elsif val == 6
      if [2,3,8].include?(dealer_show_value) && !ALLOW_DOUBLE_AFTER_SPLIT
        :hit
      elsif dealer_show_value <= 8
        :split
      else
        :hit
      end
    elsif val == 8
      if [5,6].include?(dealer_show_value)
        ALLOW_DOUBLE_AFTER_SPLIT ? :split : :double
      elsif dealer_show_value == 4
        ALLOW_DOUBLE_AFTER_SPLIT ? :split : :hit
      else
        :hit
      end
    elsif val == 10
      play_low_cards(val, dealer_show_value)
    # aces
    elsif val == 12 && soft
      :split
    elsif val == 12
      if dealer_show_value <= 6
        :split
      elsif dealer_show_value == 7
        ALLOW_DOUBLE_AFTER_SPLIT ? :split : :hit
      else
        :hit
      end
    elsif val == 14
      if dealer_show_value <= 7
        :split
      elsif dealer_show_value == 8
        ALLOW_DOUBLE_AFTER_SPLIT ? :split : :hit
      else
        :hit
      end
    elsif val == 16
      :split
    else
      if dealer_show_value == 11
        ALLOW_DOUBLE_AFTER_SPLIT ? :split : :stand
      elsif [7, 10].include?(dealer_show_value)
        :stand
      else
        :split
      end
    end
  end
end
