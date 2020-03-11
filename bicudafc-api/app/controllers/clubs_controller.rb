class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :update, :destroy]

  def index
    @clubs = Club.all
    render json: @clubs
  end

  def show
    render json: @club
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      render json: @club, status: :created, location: @club
    else
      render json: @club.errors, status: :unprocessable_entity
    end
  end

  def update
    if @club.update(club_params)
      render json: @club
    else
      render json: @club.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @club.destroy
  end

  def import_clubs
    clubs_endpoint = File.read('vendor/bkp/clubs.json')
    parsing(clubs_endpoint)
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def club_params
    params.require(:club).permit(:id_club, :name, :abbreviation, :position, :fantasy_name, :shield_30x30, :shield_45x45, :shield_60x60)
  end

  def parsing(clubs_endpoint)
    parsed_clubs = JSON.parse clubs_endpoint, symbolize_names: true
    create_clubs(parsed_clubs)
  end

  def create_clubs(parsed_clubs)
    parsed_clubs.map do |club|
      if club[1][:posicao] != nil
        Club.find_or_create_by(
          id_club: club[1][:id],
          name: club[1][:nome],
          abbreviation: club[1][:abreviacao],
          position: club[1][:posicao],
          fantasy_name: club[1][:nome_fantasia],
          shield_30x30: club[1][:escudos][:"30x30"],
          shield_45x45: club[1][:escudos][:"45x45"],
          shield_60x60: club[1][:escudos][:"60x60"]
        )
      end
    end
  end
end
