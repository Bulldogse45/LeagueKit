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
      if params[:commit] == "Create and Add Another"
        redirect_to new_location_path
      else
        redirect_to @location
      end
    else
      render 'new'
    end
  end

  def edit
    @leagues = League.where("user_id = " + current_user.id.to_s)
    @location = Location.find(params['id'])
    render 'new'
  end

  def update
    @location = Location.find(params['id'])
    if @location.update(location_params)
      flash.now[:notice] = "Your Location was updated!"
      redirect_to @location
    else
      render 'new'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to :back
  end

  private

  def location_params
    params.require(:location).permit(:name, :league_id, :address_line_1, :address_line_2, :city, :state, :zip, :notes )
  end

  def check_user_is_owner
    unless current_user == Location.find(params[:id]).league.user
      flash.now[:alert]= "You must be the Leagues's owner to access this page!"
      redirect_to root_path
    end
  end
end
