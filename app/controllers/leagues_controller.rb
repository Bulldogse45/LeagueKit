class LeaguesController < ApplicationController

  def index
    @leagues = League.where("user_id = " + current_user.id.to_s)
  end

  def new
    @league = League.new
  end

  def show
    @league = League.find(params['id'])
  end

  def create
    @league = League.new(league_params)
    @league.user = current_user
    if @league.save
      redirect_to @league
    else
      render 'new'
    end
  end

  private

  def league_params
    params.require(:league).permit(:name)
  end

end
