class Stats
  BLACKJACK_PAYOUT = (6.to_f / 5)

  def initialize
    @losses = 0
    @wins = 0
    @pushes = 0
  end

  def record_player_loss(player)
    @losses += player.doubled? ? 2 : 1
  end

  def record_player_win(player)
    @wins += player.doubled? ? 2 : 1
  end

  def record_push(player)
    @pushes += player.doubled? ? 2 : 1
  end

  def record_blackjack
    @wins += BLACKJACK_PAYOUT
  end

  def compute_player_edge
    (@wins - @losses).to_f * 100 / (@wins + @losses + @pushes)
  end

  def get_summary
    total = @wins + @losses + @pushes
    winning_percentage = @wins.to_f / (total)
    "Over #{total} hands the player won #{winning_percentage * 100} \% of the time\n" \
    "And pushed #{@pushes.to_f * 100 / total} \% of the time\n" \
    "For edge of #{compute_player_edge} \%"
  end
end
