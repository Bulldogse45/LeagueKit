class GamesController < ApplicationController

  before_action :check_user_is_tournament_owner, only: [:edit, :update, :create]
  before_action :require_user
  
  def index
    team_ids = "(" + current_user.teams.collect{|t| t.id}.join(",") +")"
    @games = Game.where("home_team_id IN #{team_ids} OR away_team_id IN #{team_ids}"  )
  end

  def new
    @game = Game.new
    if params[:tournament_id]
      @game.tournament = Tournament.find(params[:tournament_id])
    else
      flash[:alert] = "You must create a tournament to add a game"
      redirect_to tournaments_path
    end
    @teams = @game.tournament.teams
    @locations = []
  end

  def show
    @game = Game.find(params['id'])
    @home_team = Team.find(@game.home_team_id)
    @away_team = Team.find(@game.away_team_id)
  end

  def edit
    @game = Game.find(params[:id])
    render 'new'
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      flash[:notice] = "Your game was updated!"
      redirect_to game_path(@game)
    else
      flash[:alert] = @game.errors
      render 'new'
    end
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      current_user.follow(@game)
      team_members_follow_game(@game)
      redirect_to @game
    else
      render 'new'
    end
  end

  private

  def game_params
    params.require(:game).permit(:home_team_id, :away_team_id, :tournament_id, :location_id, :begin_time )
  end

  def team_members_follow_game(game)
    Team.find(game.home_team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(game)
      UserMailer.new_follow(user, game).deliver
    end
    Team.find(game.away_team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(game)
      UserMailer.new_follow(user, game).deliver
    end
  end

  def check_user_is_tournament_owner
    unless current_user == Tournament.find(params[:game][:tournament_id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end

end
