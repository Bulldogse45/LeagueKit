class LocationsController < ApplicationController

  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :require_user

  def index
    @locations = Location.where("league_id = " + params['id'])
  end

  def new
    @location = Location.new
    @leagues = League.where("user_id = " + current_user.id.to_s)
  end

  def show
    @location = Location.find(params['id'])
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location
    else
      render 'new'
    end
  end

  def edit
    @location = Location.find(params['id'])
    render 'new'
  end

  def update
    @location = Location.find(params['id'])
    if @location.update(location_params)
      flash[:notice] = "Your Location was updated!"
      redirect_to @location
    else
      render 'new'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :league_id, :address_line_1, :address_line_2, :city, :state, :zip )
  end

  def check_user_is_owner
    unless current_user == Location.league.user
      flash[:alert]= "You must be the Leagues's owner to access this page!"
      redirect_to root_path
    end
  end
end
