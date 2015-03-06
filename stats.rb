class Stats
  BLACKJACK_PAYOUT = 1.5

  def initialize
    @losses = 0
    @wins = 0
    @pushes = 0
  end

  def record_player_loss
    @losses += 1
  end

  def record_player_win
    @wins += 1
  end

  def record_push
    @pushes += 1
  end

  def record_blackjack
    @wins += BLACKJACK_PAYOUT
  end

  def get_summary
    total = @wins + @losses + @pushes
    winning_percentage = @wins.to_f / (total)
    "Over #{total} hands the player won #{winning_percentage * 100} \% of the time\n" \
    "And pushed #{@pushes.to_f * 100 / total} \% of the time"
  end
end
