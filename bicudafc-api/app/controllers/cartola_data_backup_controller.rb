class CartolaDataBackupController < ApplicationController
  def initialize
    round_data
    club_data
  end

  def round_data
    rounds = File.read('vendor/rodadas.json')
    rounds_backup(rounds)
  end

  def club_data
    clubs = File.read('vendor/clubes.json')
    clubs_backup(clubs)
  end

  private

  def rounds_backup(rounds)
    out_file = File.new('vendor/bkp/rounds.json', 'w')
    out_file.puts(rounds)
    out_file.close
    puts "Backup de RODADAS realizado com sucesso!"
  end

  def clubs_backup(clubs)
    out_file = File.new('vendor/bkp/clubs.json', 'w')
    out_file.puts(clubs)
    out_file.close
    puts "Backup de CLUBES realizado com sucesso!"
  end
end
