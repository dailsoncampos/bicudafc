class RoundsDataBackup
  def initialize
    @rounds_file = 'vendor/bkp/rounds.json'
    File.file?(@rounds_file) ? see_current_round(@rounds_file) : rounds_data('/rodadas', 'rounds')
  end

  private

  def rounds_data(endpoint, *storage_path, file_name)
    cartola = CartolaDataBackup.new
    cartola.get_data(endpoint, *storage_path, file_name)
    see_current_round(@rounds_file)
  end

  def see_current_round(file)
    current_date = Date.parse('2020-08-09').strftime("%Y-%m-%d") # Date.today.strftime("%Y-%m-%d")
    rounds = File.read(file)
    rounds_parsed = JSON.parse rounds, symbolize_names: true

    rounds_parsed.each do |round|
      round_start_date = Date.parse(round[:inicio]).strftime("%Y-%m-%d")
      make_directory(round) if current_date >= round_start_date
    end
  end

  def make_directory(round)
    Dir.mkdir('vendor/bkp/round_' + round[:rodada_id].to_s) if !Dir.exist?('vendor/bkp/round_' + round[:rodada_id].to_s)
  end
end