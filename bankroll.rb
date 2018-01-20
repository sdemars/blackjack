class Bankroll
	# Allow negative values of chips (for overall stat purposes)
	# Set to false to throw exception when player is bankrupt, for example for risk of ruin
	ALLOW_NEGATIVE = true

  def initialize(chip_count)
  	@initial_count = chip_count
    @chip_count = chip_count
    @bet = nil
    @num_rounds = 0
  end

  # TODO factor this out into a betting class, this is for basic 'dumb' betting strategy
  def get_and_record_bet(count)
  	@bet = 1
  	if @chip_count < @bet && !ALLOW_NEGATIVE
  		raise "Not enough chips to bet"
  	else 
  		@chip_count = @chip_count - @bet
  	end
  	
  	@bet
  end

  def reset_bet
  	@num_rounds = @num_rounds + 1
  	@bet = nil 
  end

  def record_player_win
  	raise "No bet on table" if @bet.nil?

  	@chip_count = @chip_count + @bet * 2
  	reset_bet
  end

  def record_player_loss
		raise "No bet on table" if @bet.nil?

  	reset_bet
  end

  def record_blackjack(blackjack_payout_ratio)
  	raise "No bet on table" if @bet.nil?

  	@chip_count = @chip_count + @bet * (1 + blackjack_payout_ratio)
  	reset_bet
  end

  def record_surrender
    # This is always the same across rule types
    surrender_ratio = 0.5
    @chip_count = @chip_count - @bet * surrender_ratio
    reset_bet
  end

  def record_push
  	raise "No bet on table" if @bet.nil?

  	@chip_count = @chip_count + @bet
  	reset_bet
  end

  def compute_realized_edge
  	(@chip_count - @initial_count).to_f * 100 / @num_rounds
  end
end