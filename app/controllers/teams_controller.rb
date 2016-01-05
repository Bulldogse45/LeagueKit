class TeamsController < ApplicationController
  before_action :require_user
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :check_user_is_tournament_owner, only: [:clone]

  def index
    @tournament_teams = []
    Team.joins(:tournament).where("teams.id != original_id AND tournaments.start_time > '#{(Time.now-72.hours).to_s}'").order("tournaments.start_time ASC").each do |t|
      if current_user.following?(t)
        @tournament_teams << t
      end
    end
    @teams =[]
    Team.where("teams.id == original_id").each do |t|
      if current_user.following?(t)
        @teams << t
      end
    end

  end

  def new
    @team = Team.new
  end

  def all
    @tournament = Tournament.find(params[:tournament_id])
    @teams = Team.where("id = original_id AND original_id NOT IN (#{@tournament.teams.collect{|t| t.original_id}.join(",")})")
    @team = Team.new
  end

  def show
    @team = Team.find(params['id'])
  end

  def clone
    @team = Team.new(team_params)
    @team.name = Team.find(params['team']['original_id'].to_i).name
    @team.user = Team.find(params['team']['original_id'].to_i).user
    if @team.save
      current_user.follow(@team)
      Team.find(@team.original_id).players.each do |p|
        @team.players << p
      end
      team_members_follow_tournament(@team.tournament_id, @team.id)
      redirect_to @team.tournament
    else
      flash.now[:alert] = @team.errors
      redirect_back_or_default root_path
    end
  end

  def edit
    @team = Team.find(params[:id])
    render 'new'
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      flash.now[:notice] = "Your team was updated!"
      redirect_to team_path(@team)
    else
      flash.now[:alert] = @team.errors
      render 'new'
    end
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      @team.update(original_id:@team.id)
      current_user.follow(@team)
      redirect_to @team
    else
      render 'new'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.games.each do |g|
      g.destroy
    end
    @team.destroy
    redirect_to :back
  end

  private

  def team_params
    params.require(:team).permit(:name, :original_id, :tournament_id, :team_logo )
  end

  def team_members_follow_tournament(tournament_id, team_id)
    tournament = Tournament.find(tournament_id)
    Team.find(team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(tournament)
      UserMailer.new_follow(user, tournament).deliver
    end
  end

  def check_user_is_owner
    unless current_user == Team.find(params['id']).user
      flash.now[:alert]= "You must be the Team's owner to access this page!"
      redirect_to root_path
    end
  end

  def check_user_is_tournament_owner
    unless current_user == Tournament.find(params[:team][:tournament_id]).user
      flash.now[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end
end
