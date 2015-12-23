class WelcomeController < ApplicationController

  before_action :require_user, only: [:index]
  layout false, only: [:landing]

  def index
    if current_user_session
      follower_ids = ""
      current_user.all_following.each do |f|
        follower_ids = follower_ids +", "+ f.id.to_s
      end
      @announces = Announce.where("announcable_id IN (" + current_user.id.to_s + follower_ids+")").order(:created_at.to_s + " DESC").page(params['page']).per(5)
      @team_announces = Announce.where("announcable_type = 'Team' AND announcable_id IN (" + current_user.id.to_s + follower_ids+")")
      @tournament_announces = Announce.where("announcable_type = 'Tournament' AND announcable_id IN (" + current_user.id.to_s + follower_ids+")")
      @league_announces = Announce.where("announcable_type = 'League' AND announcable_id IN (" + current_user.id.to_s + follower_ids+")")
      @game_announces = Announce.where("announcable_type = 'Game' AND announcable_id IN (" + current_user.id.to_s + follower_ids+")")
      respond_to do |format|
        format.json{
          render json: @announces, serializer: AnnounceSerializer
        }
        format.html{

        }
      end
    else
      @announces = []
    end

    def landing

    end
  end

end
