# frozen_string_literal: true

class Folder
  def initialize(params)
    @season = look_season(params[:content])
    @backup_path = params[:backup_path]
    @file_name = params[:file_name]
  end

  def make
    Dir.mkdir "#{@backup_path}/cartola" unless File.directory?("#{@backup_path}/cartola")
    Dir.mkdir "#{@backup_path}/cartola/seasons" unless File.directory?("#{@backup_path}/cartola/seasons")
    Dir.mkdir "#{@backup_path}/cartola/seasons/#{@season}" unless File.directory?("#{@backup_path}/cartola/seasons/#{@season}")
    current_season = "#{@backup_path}/cartola/seasons/#{@season}"
  rescue StandardError => e
    puts "Ocorreu o seguinte erro ao tentar criar diretório: #{e.message}"
  end

  def look_season(file)
    file_parsed = JSON.parse file, symbolize_names: true
    return file_parsed.first[:inicio][0..3] if file_parsed.first[:rodada_id] == 1
  end
end
