class RoundsDataBackup
  def initialize
    @cartola = CartolaDataBackup.new
    @rounds_file = "#{Rails.root.join('vendor')}/bkp/rounds.json"
    File.file?(@rounds_file) if rounds_data_updated?('/rodadas', 'rounds')
  end

  private

  def rounds_data_updated?(endpoint, file)
    @cartola.get_data(endpoint, file)
    see_current_round(@rounds_file)
  end

  def see_current_round(file)
    current_date = Date.today
    rounds = File.read(file)
    rounds_parsed = JSON.parse rounds, symbolize_names: true

    rounds_parsed.each do |round|
      round_start_date = Date.parse(round[:inicio])
      make_directory(round) if current_date >= round_start_date - 5.days
    end
  end

  def make_directory(round)
    Dir.mkdir "#{Rails.root.join('vendor')}/bkp/round_#{round[:rodada_id].to_s}" unless File.directory?("#{Rails.root.join('vendor')}/bkp/round_#{round[:rodada_id].to_s}")
  end
end
