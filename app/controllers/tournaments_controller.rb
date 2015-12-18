class TournamentsController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :check_user_is_league_owner, only: [:create]

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

  def edit
    @tournament = Tournament.find(params[:id])
    render 'new'
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update(tournament_params)
      flash[:notice] = "Your tournament was updated!"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = @tournament.errors
      render 'new'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start_time, :end_time, :league_id )
  end

  def check_user_is_owner
    unless current_user == Tournament.find(params[:id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end
  def check_user_is_league_owner
    unless current_user == League.find(params[:tournament][:league_id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end
end
