class Folder
  def initialize(params)
    @season = look_season(params[:content])
    @backup_path = @backup_path
    @file_name = params[:file_name]
  end

  def make
    debugger
    case
    when !File.directory?("#{@backup_path}/seasons")
      Dir.mkdir "#{@backup_path}/seasons"

    when !File.directory?("#{@backup_path}/seasons/#{@season}")
      Dir.mkdir "#{@backup_path}/seasons/#{@season}"

    else
      raise ArgumentError "Erro ao criar diretório"
    end
  rescue => e
    puts "Ocorreu o seguinte erro ao tentar criar diretório: #{e.message}"
  end

  def look_season(file)
    file_parsed = JSON.parse file, symbolize_names: true
    return file_parsed.first[:inicio][0..3] if file_parsed.first[:rodada_id] == 1
  end
end