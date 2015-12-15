class PlayersController < ApplicationController

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

  def show
    @player = Player.find(params['id'])
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

end
