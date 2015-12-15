class PlayerParticipantsController < ApplicationController

  def create
    @player = PlayerParticipant.new(player_participant_params)
    if @player.save
      redirect_to team_path(@player.team)
    else
      flash[:notice] = @player.errors
      redirect_to root_path
    end
  end

  def destroy
    @player = PlayerParticipant.find(params['id'])
    @player.destroy
  end

  private

  def player_participant_params
    params.require(:player_participant).permit(:team_id, :player_id)
  end
end
