class PlayerParticipantsController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :require_user

  def create
    @player = PlayerParticipant.new(player_participant_params)
    if @player.save
      player_follows_team(@player.team_id, @player.player_id)
      redirect_to team_path(@player.team)
    else
      flash.now[:notice] = @player.errors
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
    teams = Team.where("original_id = #{team_id}")
    user = User.find(Player.find(player_id).user_id)
    teams.each do |t|
      PlayerParticipant.create(team_id:t.id, player_id:player_id)
      user.follow(t)
      if t.tournament
        player_follows_tournament(t.tournament_id, player_id)
      end
    end
    team1 = Team.find(team_id)
    UserMailer.new_follow(user, team1).deliver
  end

  def player_follows_tournament(tournament_id, player_id)
    tournament = Tournament.find(tournament_id)
    user = User.find(Player.find(player_id).user_id)
    user.follow(tournament)
    UserMailer.new_follow(user, tournament).deliver
  end

  def check_user_is_owner
    unless current_user == Player.find(params['id'].to_i).user
      flash.now[:alert]= "You must be the player's guardian to access this page!"
      redirect_to root_path
    end
  end

end
