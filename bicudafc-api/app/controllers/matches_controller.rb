class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :update, :destroy]

  def index
    @matches = Match.all

    render json: @matches
  end

  def show
    render json: @match
  end

  def create
    @match = Match.new(match_params)

    if @match.save
      render json: @match, status: :created, location: @match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  def update
    if @match.update(match_params)
      render json: @match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:id_match, :home_club_id, :position_home_club, :away_club_id, :position_away_club, :date, :location, :match_validate, :score_home_club, :score_away_club, :performance_home_club, :performance_away_club, :round_id)
  end
end
