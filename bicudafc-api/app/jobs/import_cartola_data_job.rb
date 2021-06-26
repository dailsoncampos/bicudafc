# frozen_string_literal: true

# Start all process
class ImportCartolaDataJob < ApplicationJob
  queue_as :default

  def perform
    start_process if Market.new.status_opened?
  end

  private

  def start_process
    CartolaDataBackup.new.get_rounds
    parsing_in_the_rounds if rounds_file_created?
  end

  # move this method to CartolaDataBackup class
  def rounds_file_created?
    @current_date = DateTime.now
    if File.file?("#{Figaro.env.seasons_dir}/#{@current_date.year}/rounds.json")
      @rounds = File.read("#{Figaro.env.seasons_dir}/#{@current_date.year}/rounds.json")
    end
    @rounds.present? ? true : false
  end

  def parsing_in_the_rounds
    rounds_parsed = JSON.parse @rounds, symbolize_names: true
    rounds_parsed.each_with_index do |round, index|
      prev_round = rounds_parsed.to_a[index - 1] unless round[:rodada_id] == 1
      next_round = rounds_parsed.to_a[index + 1] unless round[:rodada_id] == 38
      if (prev_round.blank? || @current_date > prev_round[:fim]) && (next_round.present? || @current_date < next_round[:inicio])
        make_directory(round)
      end
    end
  end

  def make_directory(round)
    directory_by_round = "#{Figaro.env.seasons_dir}/#{@current_date.year}/round_#{round[:rodada_id]}"
    Dir.mkdir directory_by_round unless File.directory?(directory_by_round)

    # round_dir_path = "round_#{round[:rodada_id].to_s}"
    # clubs_data_backup(round_dir_path)
    # players_data_backup(round_dir_path)
    # matches_data_backup(round_dir_path)
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
