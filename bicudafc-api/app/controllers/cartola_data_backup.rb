class CartolaDataBackup < ApplicationController
  include HTTParty
  base_uri "https://api.cartolafc.globo.com/"

  def get_data(endpoint, *storage_path, file_name)
    response = self.class.get(endpoint, format: :plain)
    backup_data(storage_path, file_name, response)
  end

  private

  def backup_data(storage_path, file_name, content)
    root = Backup::ROOT_STORAGE
    current_file = root + file_name + '.json'
    
    if !File.file?(current_file)
      storage_path.empty? ? file = File.new(root + file_name + '.json', 'w') : file = File.new(root + storage_path[0] + file_name + '.json', 'w')
      file.puts(content)
      file.close
      puts 'Backup de realizado com sucesso!'
    else
      storage_path.empty? ? new_file = File.new(root + file_name + '_new.json', 'w') : new_file = File.new(root + storage_path[0] + file_name + '_new.json', 'w')
      new_file.puts(content)
      new_file.close
      puts 'Backup do novo arquivo realizado com sucesso!'
      versioning_file(root, file_name)
    end
  end

  def versioning_file(root, file_name)
    current_path = root + file_name + '.json'
    new_path = root + file_name + '_new.json'

    current_file = File.read(current_path)
    new_file = File.read(new_path)

    delete_rename_file(current_path, new_path) unless current_file != new_file
  end

  def delete_rename_file(old_path, new_path)
    File.delete(old_path)
    File.rename(new_path, new_path=old_path)
  end
end