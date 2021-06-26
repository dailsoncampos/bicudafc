# frozen_string_literal: true

# Create folders to JSON file's backup
class Folder
  def initialize(params)
    @season = look_season(params[:content])
    @backup_path = params[:backup_path]
    @file_name = params[:file_name]
  end

  def make
    Dir.mkdir Figaro.env.cartola_dir.to_s unless File.directory?(Figaro.env.cartola_dir.to_s)
    Dir.mkdir Figaro.env.seasons_dir.to_s unless File.directory?(Figaro.env.seasons_dir.to_s)
    Dir.mkdir "#{Figaro.env.seasons_dir}/#{@season}" unless File.directory?("#{Figaro.env.seasons_dir}/#{@season}")
    "#{Figaro.env.seasons_dir}/#{@season}"
  rescue StandardError => e
    puts "Ocorreu o seguinte erro ao tentar criar diretório: #{e.message}"
  end

  def look_season(file)
    file_parsed = JSON.parse file, symbolize_names: true
    return file_parsed.first[:inicio][0..3] if file_parsed.first[:rodada_id] == 1
  end
end
