class ClubsDataBackup < CartolaDataBackupController
  def get_data(clubes)
    byebug
		# clubs = self.class.get("/clubes", format: :plain)
		# clubs_serie_a(clubs)
	end

	private

  def clubs_serie_a(clubs)
    clubs_serie_a = []
    clubs_parsed = JSON.parse clubs, symbolize_names: true
    clubs_parsed.each do |club|
      clubs_serie_a << club if club[1][:posicao]
    end
    clubs_serie_a
    clubs_backup(clubs_serie_a)
	end
	
  def clubs_backup(clubs)
    out_file = File.new('vendor/bkp/clubs.json', 'w')#round_' + round[:rodada_id].to_s + '/clubs.json', 'w')
    out_file.puts(clubs)
    out_file.close
    puts 'Backup de CLUBES realizado com sucesso!'
  end
end