# frozen_string_literal: true

# Start all process
class ImportCartolaDataJob < ApplicationJob
  queue_as :default

  def perform
    start_process if Market.new.status_opened?
  end

  private

  attr_reader :date_now, :cartola, :year, :seasons_dir, :rounds_file

  def start_process
    cartola.rounds
    parsing_in_the_rounds if rounds_file_created?
  end


  def rounds_file_created?
    File.read(rounds_file).present? ? true : false
  end

  def parsing_in_the_rounds
    rounds_parsed = JSON.parse File.read(rounds_file), symbolize_names: true
    rounds_parsed.each_with_index do |round, index|
      prev_round = prev_round(rounds_parsed, round, index)
      next_round = next_round(rounds_parsed, round, index)
      current_round?(prev_round, next_round) ? make_directory(round) : break
    end
  end

  def prev_round(rounds_parsed, round, index)
    rounds_parsed.to_a[index - 1] unless round[:rodada_id] == 1
  end

  def next_round(rounds_parsed, round, index)
    rounds_parsed.to_a[index + 1] unless round[:rodada_id] == 38
  end

  def current_round?(prev_round, next_round)
    if (prev_round.blank? || date_now > prev_round[:fim]) &&
       (next_round.present? || date_now < next_round[:inicio])
      true
    else
      false
    end
  end

  def make_directory(round)
    directory_by_round = "#{seasons_dir}/#{year}/round_#{round[:rodada_id]}"
    Dir.mkdir directory_by_round unless File.directory?(directory_by_round)

    clubs_data_backup(directory_by_round)
    players_data_backup(directory_by_round)
    matches_data_backup(directory_by_round)
  end

  def clubs_data_backup(directory_by_round)
    cartola.other_data('/clubes', 'clubs', directory_by_round)
  end

  def players_data_backup(directory_by_round)
    cartola.other_data('/atletas/mercado', 'players', directory_by_round)
  end

  def matches_data_backup(directory_by_round)
    cartola.other_data('/partidas', 'matches', directory_by_round)
  end

  def date_now
    DateTime.now
  end

  def year
    date_now.year
  end

  def seasons_dir
    Figaro.env.seasons_dir
  end

  def cartola
    CartolaDataBackup.new
  end

  def rounds_file
    "#{seasons_dir}/#{year}/rounds.json"
  end
end
