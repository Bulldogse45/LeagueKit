class TeamsController < ApplicationController
  def index
    @teams = Team.where('user_id = '+ current_user.id.to_s)
  end

  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params['id'])
  end

  def create
    @team = Team.new(user_params)
    @team.user = current_user
    if @team.save
      redirect_to @team
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:team).permit(:name )
  end
end
