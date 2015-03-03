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
      player.deal_in(@deck.deal, @deck.deal)
    end
    dealer_cards = [@deck.deal, @deck.deal]
    @dealer.deal_in(dealer_cards[0], dealer_cards[1])
    dealer_show_card = dealer_cards[1]

    @players.each do |player|
      while(player.get_decision(dealer_show_card) == :hit)
        player.hit(@deck.deal)
      end
    end
  end

  def compute_winners_and_update_stats
    dealer_value = @dealer.busted? ? -1 : @dealer.value

    @players.each do |player|
      # If the player busts its an automatic loss regardless of if dealer busts
      if player.busted?
        @stats.record_player_loss
      end

      player_value = player.busted? ? -1 : player.value
      if player_value > dealer_value
        @stats.record_player_win
      elsif dealer_value > player_value
        @stats.record_player_loss
      else
        @stats.record_push
      end
    end
  end
end


d = Driver.new
d.play_rounds(5, 500)
