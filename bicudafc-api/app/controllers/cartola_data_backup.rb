# frozen_string_literal: true

# Get data
class CartolaDataBackup < ApplicationController
  include HTTParty
  base_uri 'https://api.cartolafc.globo.com/'

  def rounds
    content = self.class.get('/rodadas', format: :plain)
    main_file = build_path('rounds', content) if content.present?
    write_file(content, main_file) unless File.file?(main_file)
  end

  def other_data(endpoint, file_name, round_dir_path)
    response = self.class.get(endpoint, format: :plain)
    file_path = "#{round_dir_path}/#{file_name}.json"
    write_file(response, file_path) unless File.file?(file_path)
  end

  private

  def check_main_file(base_file_path)
    debugger
    current_file_path = "#{base_file_path}.json"
    income_file_path = "#{base_file_path}_new.json"

    current_file_parsed = JSON.parse(File.read("#{current_file_path}"))
    income_file_parsed = JSON.parse(File.read("#{income_file_path}"))

    if current_file_parsed == income_file_parsed
      keep_current_file(income_file_path)
    else
      update_main_file(current_file_path, income_file_path)
    end
  end

  def keep_current_file(income_file)
    File.delete(income_file)
  end

  def update_main_file(current_file_path, income_file_path)
    buffer_file = current_file_path
    File.delete(current_file_path)
    File.rename(income_file_path, buffer_file)
  end

  def build_path(file_name, content)
    current_season = Folder.new({ backup_path: Figaro.env.backup_path, content: content, file_name: file_name }).make
    base_file_path = "#{current_season}/#{file_name}"

    if File.file?("#{base_file_path}.json")
      file_path = "#{base_file_path}_new.json"
      write_file(content, file_path)
    else
      file_path = "#{base_file_path}.json"
    end
    check_main_file(base_file_path) if File.file?("#{base_file_path}.json")
    file_path
  end

  def write_file(content, file_path)
    file = File.new(file_path, 'w')
    file.puts(content)
    file.close
    puts 'Backup de realizado com sucesso!'
  end
end
