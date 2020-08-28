class RoundsDataBackup
  def initialize
    @cartola = CartolaDataBackup.new
    rounds_data('/rodadas', 'rounds')
    see_current_round
  end

  private

  def rounds_data(endpoint, file_name)
    @cartola.get_data_rounds(endpoint, file_name)
  end

  def see_current_round
    current_date = DateTime.now
    rounds = File.read("#{Rails.root.join('vendor')}/bkp/rounds.json")
    rounds_parsed = JSON.parse rounds, symbolize_names: true

    rounds_parsed.each_with_index do |round, index|
      prev_round = rounds_parsed.to_a[index - 1]
      next_round = rounds_parsed.to_a[index + 1]
      round_start_date = DateTime.parse(round[:inicio])

      make_directory(round) if current_date > prev_round[:fim] && current_date < next_round[:inicio]

    end
  end

  def make_directory(round)
    directory_by_round = "#{Rails.root.join('vendor')}/bkp/round_#{round[:rodada_id].to_s}"
    Dir.mkdir directory_by_round unless File.directory?(directory_by_round)

    round_dir_path = "round_#{round[:rodada_id].to_s}"
    clubs_data_backup(round_dir_path)
    players_data_backup(round_dir_path)
    matches_data_backup(round_dir_path)
  end

  def clubs_data_backup(round_dir_path)
    @cartola.get_other_data('/clubes', 'clubs', round_dir_path)
  end

  def players_data_backup(round_dir_path)
    @cartola.get_other_data('/atletas/mercado', 'players', round_dir_path)
  end

  def matches_data_backup(round_dir_path)
    @cartola.get_other_data('/partidas', 'matches', round_dir_path)
  end
end
