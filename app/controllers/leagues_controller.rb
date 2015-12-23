class LeaguesController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :require_user

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

  def edit
    @league = League.find(params['id'])
    render 'new'
  end

  def update
    @league = League.find(params['id'])
    if @league.update(league_params)
      flash[:notice] = "Your League was updated!"
      redirect_to @league
    else
      render 'new'
    end
  end

  private

  def league_params
    params.require(:league).permit(:name)
  end

  def check_user_is_owner
    unless current_user == League.find(params['id'].to_i).user
      flash[:alert]= "You must be the Leagues's owner to access this page!"
      redirect_to root_path
    end
  end

end
