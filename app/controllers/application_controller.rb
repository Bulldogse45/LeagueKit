class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user


  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        flash.now[:notice] = "You must be logged in to access this page"
        redirect_to landing_path
        return false
      end
      assign_teams_tournaments_leagues
    end

    def assign_teams_tournaments_leagues
      @my_teams = Team.where("id = original_id AND user_id = ?", current_user.id.to_s)
      @my_tournaments = Tournament.where("user_id = ?", current_user.id.to_s)
      @my_leagues = League.where("user_id = ?", current_user.id.to_s)
      @my_players = current_user.players
    end

    def require_no_user
      if current_user
        flash.now[:notice] = "You must be logged out to access this page"
        redirect_to :back
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
