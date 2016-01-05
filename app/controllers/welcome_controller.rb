class WelcomeController < ApplicationController

  before_action :require_user, only: [:index]
  layout false, only: [:landing]

  def index
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
      @team_announces = Announce.joins(:announcement_viewed).where("viewed = 'false' AND announcable_type = 'Team' AND announcable_id IN (" + team_follower_ids.join(",")+")")
      @tournament_announces = Announce.joins(:announcement_viewed).where("viewed = 'false' AND announcable_type = 'Tournament' AND announcable_id IN (" + tournament_follower_ids.join(",")+")")
      @league_announces = Announce.joins(:announcement_viewed).where("viewed = 'false' AND announcable_type = 'League' AND announcable_id IN (" + league_follower_ids.join(",")+")")
      @game_announces = Announce.joins(:announcement_viewed).where("viewed = 'false' AND announcable_type = 'Game' AND announcable_id IN (" +game_follower_ids.join(",")+")")
      @announces = Announce.joins(:announcement_viewed).where("viewed = 'false' AND announcable_type = 'Game' AND announcable_id IN (" + game_follower_ids.join(",")+") OR viewed = 'false' AND announcable_type = 'Team' AND announcable_id IN (" + team_follower_ids.join(",")+") OR viewed = 'false' AND announcable_type = 'Tournament' AND announcable_id IN (" + tournament_follower_ids.join(",") + ") OR viewed = 'false' AND announcable_type = 'League' AND announcable_id IN (" + league_follower_ids.join(",")+")").page(params['page']).per(5)
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
