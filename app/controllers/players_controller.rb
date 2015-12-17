class PlayersController < ApplicationController
  before_action :check_user_is_owner, only: [:edit, :update]

  def index
    @players = Player.where("user_id = " + current_user.id.to_s)
  end

  def new
    @player = Player.new
  end

  def all
    @player_participant = PlayerParticipant.new
    @players = Player.all
  end

  def edit
    @player = Player.find(params['id'])
    render 'new'
  end

  def show
    @player = Player.find(params['id'])
    @teams = Team.joins(:player_participants).where("player_id = #{@player.id}")
  end

  def create
    @player = Player.new(user_params)
    @player.user = current_user
    if @player.save
      redirect_to @player
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:player).permit(:first_name, :last_name, :suffix, :jersey_number, :date_of_birth )
  end

  def team(team)
    self.team = team
    self.save
  end

  def check_user_is_owner
    unless current_user == Player.find(params['id'].to_i).user
      flash[:alert]= "You must be the player's guardian to access this page!"
      redirect_to root_path
    end
  end

end
