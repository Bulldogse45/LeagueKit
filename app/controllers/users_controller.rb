class UsersController < ApplicationController
  before_action :require_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.create_confirmation(@user).deliver
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params['id'].to_i)
    @teams = Team.where('user_id = '+ @user.id.to_s).where('id = original_id')
    @players = Player.where("user_id = " + @user.id.to_s)
    @tournaments = Team.where('user_id = '+ @user.id.to_s).where('id != original_id')
    @owned_tournaments = Tournament.where("user_id = " + @user.id.to_s)
  end

  def edit
    @user = User.find(current_user.id)
    render 'new'
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      flash[:notice] = "Update Successful!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :address_1, :address_2, :city, :state, :zip, :phone1, :phone2, :phone3, :phone4, :phone5, :email_optout)
  end

end
