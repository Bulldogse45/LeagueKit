class TeamsController < ApplicationController
  def index
    @teams = Team.where('user_id = '+ current_user.id.to_s)
  end

  def new
    @team = Team.new
  end

  def all
    @teams = Team.all
    @team = Team.new
  end

  def show
    @team = Team.find(params['id'])
  end

  def clone
    @team = Team.new(team_params)
    @team.name = Team.find(params['team']['original_id']).name
    @team.user = Team.find(params['team']['original_id']).user
    Team.find(params['team']['original_id']).players.each do |p|
      @team.players << p
    end
    if @team.save
      redirect_to @team.tournament
    else
      flash[:notice] = @team.errors
      redirect_back_or_default root_path
    end
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      redirect_to @team
    else
      render 'new'
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :original_id, :tournament_id )
  end
end
