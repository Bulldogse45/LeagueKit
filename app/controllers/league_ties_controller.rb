class LeagueTiesController < ApplicationController
  before_action :require_user, :check_user_is_owner_or_coach

  def destroy
    @league_ty = LeagueTy.find(params[:id])
    @league_ty.destroy
    flash[:success] = "Team was removed"
    redirect_to :back
  end

  private

  def check_user_is_owner_or_coach
    unless current_user ==  LeagueTy.find(params[:id]).league.user
      flash[:alert] = "You need to be the tournament director to remove a team"
      redirect_to :back
    end
  end

end
