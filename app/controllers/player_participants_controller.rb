class PlayerParticipantsController < ApplicationController

  def create
    @player = PlayerParticipant.new(player_participant_params)
    if @player.save
      player_follows_team(@player.team_id, @player.player_id)
      if @player.team.tournament
        player_follows_tournament(@player.team.tournament_id, @player.player_id)
      end
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

  def player_follows_team(team_id, player_id)
    team = Team.find(team_id)
    user = User.find(Player.find(player_id).user_id)
    user.follow(team)
  end

  def player_follows_tournament(tournament_id, player_id)
    tournament = Tournament.find(tournament_id)
    user = User.find(Player.find(player_id).user_id)
    user.follow(tournament)
  end

end
