class CartolaDataBackup < ApplicationController
  include HTTParty
  base_uri "https://api.cartolafc.globo.com/"

  def initialize(endpoint, file_name)
    response = self.class.get(endpoint, format: :plain)
    Folder.new({backup_path: Figaro.env.backup_path, content: response, file_name: file_name}).make
    debugger

    # file_path = "#{Figaro.env.backup_path}#{file_name}.json"

    # write_file(response, file_path)
  end

  def get_other_data(endpoint, file_name, *round_dir_path)
    response = self.class.get(endpoint, format: :plain)

    # response = clubs_serie_a(response) if endpoint == '/clubes'

    root = Rails.root.join('vendor')

    file_path = "#{root}/bkp/#{round_dir_path[0]}/#{file_name}.json"

    write_file(response, file_path) if !File.file?(file_path)
  end

  private

  def write_file(content, file_path)
    file = File.new(file_path, 'w')
    file.puts(content)
    file.close
    puts 'Backup de realizado com sucesso!'
  end
end
