class AnnouncesController < ApplicationController

  before_filter :load_announcable, :except =>[:all]
  before_filter :check_user_is_affiliated, :only => [:index, :new, :create]
  before_action :require_user

  def index
    @announces = @announcable.announces.order('created_at DESC').page(params['page']).per(10)
    if @announcable.class.to_s == "Team"
      unless current_user.following?(@announcable)
        flash[:alert]= "You are not authorized to view this page"
        redirect_to user_path(current_user)
      end
    end
  end

  def all
    if current_user_session
      team_follower_ids = [0]
      tournament_follower_ids = [0]
      game_follower_ids = [0]
      league_follower_ids = [0]
      current_user.all_following.each do |f|
        if f.class.to_s == "Game"
          game_follower_ids <<  f.id.to_s
        elsif f.class.to_s == "Team"
          team_follower_ids <<  f.id.to_s
        elsif f.class.to_s == "Tournament"
          tournament_follower_ids <<  f.id.to_s
        elsif f.class.to_s == "League"
          league_follower_ids  <<  f.id.to_s
        end
      end
      @team_announces = Announce.joins(:announcement_viewed).where("announcable_type = 'Team' AND announcable_id IN (" + team_follower_ids.join(",")+")")
      @tournament_announces = Announce.joins(:announcement_viewed).where("announcable_type = 'Tournament' AND announcable_id IN (" + tournament_follower_ids.join(",")+")")
      @league_announces = Announce.joins(:announcement_viewed).where("announcable_type = 'League' AND announcable_id IN (" + league_follower_ids.join(",")+")")
      @game_announces = Announce.joins(:announcement_viewed).where("announcable_type = 'Game' AND announcable_id IN (" +game_follower_ids.join(",")+")")
      @announces = Announce.joins(:announcement_viewed).where("announcable_type = 'Game' AND announcable_id IN (" + game_follower_ids.join(",")+") OR announcable_type = 'Team' AND announcable_id IN (" + team_follower_ids.join(",")+") OR announcable_type = 'Tournament' AND announcable_id IN (" + tournament_follower_ids.join(",") + ") OR announcable_type = 'League' AND announcable_id IN (" + league_follower_ids.join(",")+")").order('created_at DESC').page(params['page']).per(10)

      render 'welcome/index'
    end
  end

  def show
    @announce = Announce.find(params[:id])
  end

  def new
    @announce = Announce.new
  end

  def create
    @announce = @announcable.announces.new(announce_params)
    if @announce.save
      AnnouncementViewed.create(user_id:current_user.id, announce_id:@announce.id, viewed:false)
      flash.now[:notice] = "Announcement successful!"
      @announcable.followers.each do |f|
        UserMailer.announcement_notification(f, @announce).deliver
      end
      redirect_to [@announcable, :announces]
    else
      flash.now[:alert] = @announce.errors
      render 'new'
    end
  end

  def mark_announcement_as_read
    @announce = Announce.find(params[:id])
    @announce.announcement_viewed.update!(viewed:true)
    redirect_to :back
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
      unless current_user.following?(@announcable) || @announcable.user == current_user
        flash[:alert]= "You are not permitted to view this page."
        redirect_to root_path
      end
    else
      flash[:notice]= "You must be logged and allowed to view this page."
      redirect_to root_path
    end
  end

end
