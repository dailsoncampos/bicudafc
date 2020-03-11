class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :update, :destroy]

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def show
    render json: @round
  end

  def create
    @round = Round.new(round_params)

    if @round.save
      render json: @round, status: :created, location: @round
    else
      render json: @round.errors, status: :unprocessable_entity
    end
  end

  def update
    if @round.update(round_params)
      render json: @round
    else
      render json: @round.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @round.destroy
  end

  def import_rounds
    rounds_endpoint = File.read('vendor/bkp/rounds.json')
    parsing(rounds_endpoint)
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end

  def round_params
    params.require(:round).permit(:start_date, :end_date)
  end

  def parsing(rounds_endpoint)
    parsed_rounds = JSON.parse rounds_endpoint, symbolize_names: true
    create_rounds(parsed_rounds)
  end

  def create_rounds(parsed_rounds)
    parsed_rounds.index.map do |round|
      Round.find_or_create_by(
        start_date: round[:inicio],
        end_date: round[:fim]
      )
    end
  end
end
