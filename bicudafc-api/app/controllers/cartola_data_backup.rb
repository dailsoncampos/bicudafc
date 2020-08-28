class CartolaDataBackup < ApplicationController
  include HTTParty
  base_uri "https://api.cartolafc.globo.com/"

  def get_data_rounds(endpoint, file_name)
    response = self.class.get(endpoint, format: :plain)
    root = Rails.root.join('vendor')

    file_path = "#{root}/bkp/#{file_name}.json"

    backup_data(response, file_path) 
  end

  def get_other_data(endpoint, file_name, *round_dir_path)

    response = self.class.get(endpoint, format: :plain)

    response = clubs_serie_a(response) if endpoint == '/clubes'

    root = Rails.root.join('vendor')

    file_path = "#{root}/bkp/#{round_dir_path[0]}/#{file_name}.json"

    backup_data(response, file_path) if !File.file?(file_path)
  end

  private

  def clubs_serie_a(clubs)
    clubs_serie_a = []
    clubs_parsed = JSON.parse clubs, symbolize_names: true
    clubs_parsed.each do |club|
      clubs_serie_a << club if club[1][:posicao]
    end
    clubs_serie_a.to_json
  end

  def backup_data(content, file_path)
    file = File.new(file_path, 'w')
    file.puts(content)
    file.close
    puts 'Backup de realizado com sucesso!'
  end
end
