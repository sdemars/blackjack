class Stats
  BLACKJACK_PAYOUT = (6.to_f / 5)

  def initialize
    @by_count = {}
    # Temp until factor out
    @player_bankrolls = []
  end

  def init_for_count(count)
    @by_count[count] = {
      :losses => 0,
      :wins => 0,
      :pushes => 0
    }
  end

  def record_bankrolls(bankrolls)
    @player_bankrolls.append(bankrolls)
  end

  def record_player_loss(player, count)
    init_for_count(count) if @by_count[count].nil?
    @by_count[count][:losses] += player.doubled? ? 2 : 1
  end

  def record_player_win(player, count)
    init_for_count(count) if @by_count[count].nil?
    @by_count[count][:wins] += player.doubled? ? 2 : 1
  end

  def record_push(player, count)
    init_for_count(count) if @by_count[count].nil?
    @by_count[count][:pushes] += player.doubled? ? 2 : 1
  end

  def record_blackjack(count)
    init_for_count(count) if @by_count[count].nil?
    @by_count[count][:wins] += BLACKJACK_PAYOUT
  end

  def record_surrender(count)
    init_for_count(count) if @by_count[count].nil?
    # Count a surrender as half a loss
    @by_count[count][:losses] += 0.5
  end

  def get_total_stats_hash(hash = nil)
    hash ||= @by_count
    hash.inject({wins: 0, losses: 0, pushes:0}) do |total, (count, values)|
      total[:wins] += values[:wins]
      total[:losses] += values[:losses]
      total[:pushes] += values[:pushes]
      total
    end
  end

  def compute_player_edge(hash)
    (hash[:wins] - hash[:losses]).to_f * 100 / (hash[:wins] + hash[:losses] + hash[:pushes])
  end

  def get_bucketed_stats_by_count
    min = -5
    max = 5
    bucketed_hash = {}
    bucketed_hash[min] =
        get_total_stats_hash(@by_count.select { |x| x < min })
    bucketed_hash[max] =
        get_total_stats_hash(@by_count.select { |x| x < max })
    ((min+1)..(max-1)).each do |x|
      bucketed_hash[x] = @by_count[x]
    end

    bucketed_hash.inject({}) do |h, (count, stats)|
      h[count] = compute_player_edge(stats)
      h
    end
  end

  def get_summary
    total = get_total_stats_hash
    #puts "total at the end is #{total}"
    total_hands = total[:wins] + total[:losses] + total[:pushes]
    winning_percentage = total[:wins].to_f / (total_hands)


    "Over #{total_hands} hands the player won #{winning_percentage * 100} \% of the time\n" \
    "And pushed #{total[:pushes].to_f * 100 / total_hands} \% of the time\n" \
    "For edge of #{compute_player_edge(total)} \%\n\n" \
    "Overall stats are:\n #{print_hash(get_bucketed_stats_by_count)}"
  end

  def print_hash(hash)
    str = ""
    sorted_keys = hash.keys.sort
    sorted_keys.each do |k|
      str += "#{k}: #{hash[k]}\n"
    end
    str
  end
end
