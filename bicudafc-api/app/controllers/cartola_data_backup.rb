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

  def build_path(file_name, content)
    current_season = Folder.new({ backup_path: Figaro.env.backup_path, content: content, file_name: file_name }).make
    base_file_path = "#{current_season}/#{file_name}.json"
    if File.file?(base_file_path) && !contents_are_equals?(base_file_path, content)
      update_main_file(base_file_path, content)
    else
      base_file_path
    end
  end

  def contents_are_equals?(current_file, income_content)
    income_file = JSON.parse income_content, symbolize_names: true
    current_content = JSON.parse(File.read("#{current_file}"))
    current_file_values = current_content.map(&:values)
    income_file_values = income_file.map(&:values)
    return true if current_file_values == income_file_values
  end

  def update_main_file(current_file_path, content)
    buffer_file = current_file_path
    File.delete(current_file_path)
    write_file(content, buffer_file)
    buffer_file
  end

  def write_file(content, file_path)
    file = File.new(file_path, 'w')
    file.puts(content)
    file.close
    puts 'Backup de realizado com sucesso!'
  end
end
