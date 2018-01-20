require './deck'
require './player'
require './stats'
require './basic_strategy'
require './dealer_strategy'
require './bankroll.rb'

class Driver
  def play_rounds(num_players, num_rounds)
    @stats = Stats.new

    initialize_players(num_players)

    @deck = Deck.new
    num_rounds.times do
      count = @deck.count
      play_round

      compute_winners_and_update_stats(count)

      if @deck.running_low?
        @deck.shuffle
      end
    end

    puts @stats.get_summary
    # Temp debug
    @players.each do |p|
      puts "for player #{p} bankroll edge is #{p.bankroll.compute_realized_edge}"
    end
  end

  def initialize_players(num_players)
    @players = []
    (num_players - 1).times do
      @players << Player.new(BasicStrategy, Bankroll.new(0))
    end
    # Add the dealer
    @dealer = Player.new(DealerStrategy, Bankroll.new(0))
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
      #puts "decision is #{decision} for player #{player}"
      if decision == :surrender
        player.surrender
        break
      elsif decision == :hit
        player.hit(@deck.deal)
      elsif decision == :split
        player.split
        #puts "player #{player} doubled to #{player.doubled_hand}"
        play_for_individual(player.split_hand, dealer_show_card)
      elsif decision == :double
        player.double_up
        player.hit(@deck.deal)
        break
      end
      decision = player.get_decision(dealer_show_card)
    end
  end

  def compute_winners_and_update_stats(count)
    dealer_value = @dealer.busted? ? -1 : @dealer.value

    @players.each do |player|
      record_stats_for_player(player, dealer_value, count)
    end
  end

  def record_stats_for_player(player, dealer_value, count)
    # If the player busts its an automatic loss regardless of if dealer busts
    if player.blackjack?
      @stats.record_blackjack(count)
      # TODO pass in reference
      player.bankroll.record_blackjack(1.5)
    elsif player.surrendered?
      # TODO should this count as a loss or a partial loss
      player.bankroll.record_surrender
      @stats.record_surrender(count)
    elsif player.busted?
      player.bankroll.record_player_loss
      @stats.record_player_loss(player, count)
    elsif player.value > dealer_value
      player.bankroll.record_player_win
      @stats.record_player_win(player, count)
    elsif dealer_value > player.value
      player.bankroll.record_player_loss
      @stats.record_player_loss(player, count)
    else
      player.bankroll.record_push
      @stats.record_push(player, count)
    end

    # handle doubled hands
    # TODO handle this in bankroll (refactor it out probably)
    record_stats_for_player(player.split_hand, dealer_value, count) if player.split?
  end
end

d = Driver.new
d.play_rounds(5, 5000)
