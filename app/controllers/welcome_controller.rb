class WelcomeController < ApplicationController

  def index
    if current_user_session
      follower_ids = ""
      current_user.all_following.each do |f|
        follower_ids = follower_ids +", "+ f.id.to_s
      end
      @announces = Announce.select("announces.*").where("announcable_id IN (" + current_user.id.to_s + follower_ids+")").order(:created_at.to_s + " DESC").page(params['page']).per(5)
    else
      @announces = []
    end
  end

end
