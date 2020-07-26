class CartolaDataBackup < ApplicationController
  include HTTParty
  base_uri "https://api.cartolafc.globo.com/"

  def get_data(endpoint, *storage_path, file_name)
    response = self.class.get(endpoint, format: :plain)
    backup_data(storage_path, file_name, response, endpoint)
  end

  private

  def backup_data(storage_path, file_name, content, endpoint)
    root = Backup::ROOT_STORAGE
    storage_path.empty? ? file = File.new(root + file_name + '.json', 'w') : file = File.new(root + storage_path[0] + file_name + '.json', 'w')
    file.puts(content)
    file.close
    puts 'Backup de realizado com sucesso!'
  end
end