class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.where("user_id = " + current_user.id.to_s)
  end

  def new
    @tournament = Tournament.new
  end

  def show
    @tournament = Tournament.find(params['id'])
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.user = current_user
    if @tournament.save
      redirect_to @tournament
    else
      render 'new'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start_time, :end_time, :league_id )
  end
end
