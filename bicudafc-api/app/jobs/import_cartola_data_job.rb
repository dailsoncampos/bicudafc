class ImportCartolaDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @cartola = CartolaDataBackup.new
    @rounds_file = "#{Rails.root.join('vendor')}/bkp/rounds.json"
    File.file?(@rounds_file) ? rounds_data_updated?('/rodadas', 'rounds') : rounds_data('/rodadas', 'rounds')
  end

  private

  def rounds_data_updated?(endpoint, file)
    @cartola.get_data(endpoint, file)
  end

  def rounds_data(endpoint, *storage_path, file_name)
    @cartola.get_data(endpoint, *storage_path, file_name)
    see_current_round(@rounds_file)
  end

  def see_current_round(file)
    current_date = Date.today
    rounds = File.read(file)
    rounds_parsed = JSON.parse rounds, symbolize_names: true

    rounds_parsed.each do |round|
      round_start_date = Date.parse(round[:inicio])
      make_directory(round) if current_date >= round_start_date - 4.days
    end
  end

  def make_directory(round)
    Dir.mkdir "#{Rails.root.join('vendor')}/bkp/round_#{round[:rodada_id].to_s}" unless File.directory?("#{Rails.root.join('vendor')}/bkp/round_#{round[:rodada_id].to_s}")
  end
end
