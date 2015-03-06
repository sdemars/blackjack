require './deck'
require './player'
require './stats'

class Driver
  def play_rounds(num_players, num_rounds)
    @stats = Stats.new

    initialize_players(num_players)

    @deck = Deck.new
    num_rounds.times do
      play_round

      compute_winners_and_update_stats

      if @deck.running_low?
        @deck.shuffle
      end
    end

    puts @stats.get_summary
  end

  def initialize_players(num_players)
    @players = []
    (num_players - 1).times do
      @players << Player.new(:basic)
    end
    # Add the dealer
    @dealer = Player.new(:dealer)
  end

  def play_round
    @players.each do |player|
      player.deal_in([@deck.deal, @deck.deal])
    end
    dealer_cards = [@deck.deal, @deck.deal]
    @dealer.deal_in([dealer_cards[0], dealer_cards[1]])
    dealer_show_card = dealer_cards[1]

    (@players + [@dealer]).each do |player|
      play_for_individual(player, dealer_show_card)
    end
  end

  def play_for_individual(player, dealer_show_card)
    decision = player.get_decision(dealer_show_card)
    while(decision != :stand)
      if decision == :hit
        player.hit(@deck.deal)
      elsif decision == :double
        player.double
        play_for_individual(player.doubled_hand, dealer_show_card)
      end
      decision = player.get_decision(dealer_show_card)
    end
  end

  def compute_winners_and_update_stats
    dealer_value = @dealer.busted? ? -1 : @dealer.value

    @players.each do |player|
      record_stats_for_player(player, dealer_value)
    end
  end

  def record_stats_for_player(player, dealer_value)
    # If the player busts its an automatic loss regardless of if dealer busts
    if player.blackjack?
      @stats.record_blackjack
    elsif player.busted?
      @stats.record_player_loss
    elsif player.value > dealer_value
      @stats.record_player_win
    elsif dealer_value > player.value
      @stats.record_player_loss
    else
      @stats.record_push
    end

    # handle doubled hands
    record_stats_for_player(player.doubled_hand, dealer_value) if player.doubled?
  end
end

d = Driver.new
d.play_rounds(5, 500)
