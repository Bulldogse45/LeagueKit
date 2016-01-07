class LeagueTiesController < ApplicationController


  def destroy
    @league_ty = LeagueTy.find(params[:id])
    @league_ty.destroy
    flash[:success] = "Team was removed"
    redirect_to :back
  end

end
