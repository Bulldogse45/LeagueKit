class AnnouncesController < ApplicationController

  before_filter :load_announcable, :check_user_is_affiliated
  before_action :require_user

  def index
    @announces = @announcable.announces.order('created_at DESC')
    respond_to do |format|
      format.json{
        render json: @announces
      }
      format.html{

      }
    end
  end

  def new
    @announce = Announce.new
  end

  def create
    @announce = @announcable.announces.new(announce_params)
    if @announce.save
      flash[:notice] = "Announcement successful!"
      @announcable.followers.each do |f|
        UserMailer.announcement_notification(f, @announce).deliver
      end
      redirect_to [@announcable, :announces]
    else
      flash[:alert] = @announce.errors
      render 'new'
    end
  end

  private

  def load_announcable
    resource, id = request.path.split('/')[1,2]
    @announcable = resource.singularize.classify.constantize.find(id)
  end

  def announce_params
    params.require(:announce).permit(:content)
  end

  def check_user_is_affiliated
    if current_user_session
      unless @announcable.followers.include?(current_user.id) || @announcable.user == current_user
        flash[:alert]= "You are not permitted to view this page."
        redirect_to root_path
      end
    else
      flash[:notice]= "You must be logged and allowed to view this page."
      redirect_to root_path
    end
  end
end
