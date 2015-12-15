class TeamParticipantsController < ApplicationController

  def create
    @team = TeamParticipant.new(team_participant_params)
    if @team.save
      redirect_to :back
    else
      flash[:notice] = @team.errors
      redirect_to root_path
    end
  end

  def destroy
    @team = TeamParticipant.find(params['id'])
    @team.destroy
  end

  private

  def team_participant_params
    params.require(:team_participant).permit(:team_id, :tournament_id)
  end

end
