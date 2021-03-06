class PlayersController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :require_user

  def index
    @players = Player.where("user_id = ?", current_user.id.to_s)
  end

  def new
    @player = Player.new
  end

  def all
    @player_participant = PlayerParticipant.new
    @players = Player.search(params[:search])
    @teams = Team.where("user_id = ? AND id = original_id", current_user.id)
  end

  def add_to_team
    @player_participant = PlayerParticipant.new
    @team = Team.find(params['team_id'])
    @teams = Team.where("user_id = ? AND id = original_id", current_user.id)
    @players = [Player.find(params['player_id'])]
    render 'all'
  end

  def search

  end

  def edit
    @player = Player.find(params['id'])
    render 'new'
  end

  def show
    @player = Player.find(params['id'])
    @teams = Team.joins(:player_participants).where("team_id = original_id AND player_id = ?", @player.id)
    @tournament_teams = Team.joins(:player_participants).where("team_id != original_id AND player_id = ?", @player.id)
  end

  def create
    @player = Player.new(player_params)
    @player.user = current_user
    if @player.save
      redirect_to @player
    else
      render 'new'
    end
  end

  def update
    @player = Player.find(params[:id])
    if username_lookup(params[:player][:username])
      @player.user = User.where("username = ?", params[:player].delete(:username)).first
      if @player.update(player_params)
        flash.now[:notice] = "Your information was updated!"
        redirect_to @player
      else
        render 'new'
      end
    else
      params[:player].delete(:username)
      flash.now[:alert] = "That is not a user in our database!"
      render 'new'
    end
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :suffix, :jersey_number, :date_of_birth, :username, :player_photo )
  end

  def team(team)
    self.team = team
    self.save
  end

  def check_user_is_owner
    unless current_user == Player.find(params['id'].to_i).user
      flash.now[:alert]= "You must be the player's guardian to access this page!"
      redirect_to root_path
    end
  end

  def username_lookup(username)
    User.find_by username: username.strip
  end

end
