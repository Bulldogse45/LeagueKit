class PlayerParticipantsController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :check_user_is_owner_or_coach, only: [:leave_team]
  before_action :require_user

  def create
    @player = PlayerParticipant.new(player_participant_params)
    if @player.team.user == current_user
      if @player.save
        player_follows_team(@player.team_id, @player.player_id)
        redirect_to team_path(@player.team)
      else
        flash[:notice] = "There was an error adding this player.  Please try again later"
        redirect_to root_path
      end
    else
      flash[:notice] = "You are not the coach of this team.  Please submit a request to the coach.  Thanks!"
      redirect_to root_path
    end
  end

  def leave_team
    @player_participant = PlayerParticipant.find(params[:id])
    pteam = @player_participant.team
    user = @player_participant.player.user
    original_team_id = @player_participant.team.original_id
    @player_participant.player.player_participants.each do |p|
      if p.team && p.team.original_id == original_team_id
        team = p.team
        p.destroy
        unless team.players.collect{|pl| pl.user_id}.include?(user.id) || team.user == user.id
          user.stop_following(team)
          if team.tournament
            user.stop_following(team.tournament)
          end
          if team.games
            team.games.each do |g|
              user.stop_following(g)
            end
          end
        end
      end
    end
    redirect_to team_path(pteam)
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

  def check_user_is_owner_or_coach
    unless current_user == PlayerParticipant.find(params['id']).player.user || current_user == PlayerParticipant.find(params['id']).team.user
      flash.now[:alert]= "You must be the player's guardian or coach to access this page!"
      redirect_to root_path
    end
  end

end
