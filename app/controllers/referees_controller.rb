class RefereesController < ApplicationController
  before_action :require_user

  def new
    @referee = Referee.new
    @tournament = Tournament.find(params[:tournament_id])
  end

  def create
    @referee = Referee.new(referee_params)
    @tournament = Tournament.find(params[:referee][:tournament_id])
    @referee.user_id = current_user.id
    if @referee.save
      flash.now[:alert] = "Thank you for volunteering!"
      redirect_to @tournament
    else
      render 'new'
    end
  end

  def edit
    @referee = Referee.find(params[:id])
  end

  def update
    @referee = Referee.find(params['id'])

  end

  private

  def referee_params
    params.require(:referee).permit(:tournament_id, :notes)
  end

end
