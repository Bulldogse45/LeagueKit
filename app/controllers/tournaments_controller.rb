class TournamentsController < ApplicationController
  before_action :require_user
  before_action :check_user_is_owner, only: [:edit, :update]

  def index
    @tournaments = []
    Tournament.where("start_time > '#{(Time.now-72.hours).to_s}'").order("start_time ASC").each do |t|
      if current_user.following?(t)
        @tournaments << t
      end
    end
  end

  def volunteer
    if current_user.referees.length > 0
      referee_tourny = "( #{current_user.referees.collect{|r| r.tournament_id}.compact.join(", ")} )"
      @referee_tournaments = Tournament.where("id IN #{referee_tourny}")
      @tournaments = Tournament.where("id NOT IN #{referee_tourny}")
    else
      @referee_tournaments = []
      @tournaments =Tournament.all
    end

  end

  def referee

    redirect_to volunteer_path
  end

  def new
    @tournament = Tournament.new
    teams = []
    current_user.leagues.each do |l|
      l.teams.each do |t|
        teams << t
      end
    end
    @teams = teams
    @leagues = League.where("user_id = " + current_user.id.to_s)
  end

  def show
    @tournament = Tournament.find(params['id'])
    @announces = @tournament.announces.page(params['page']).per(5)
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.user = current_user
    if params[:tournament][:league_id] != ""
      check_user_is_league_owner
    end
    if @tournament.save
      current_user.follow(@tournament)
      @tournament.teams.each do |t|
        t.user.follow(@tournament)
        team_members_follow_tournament(@tournament.id, t.id)
      end
      redirect_to @tournament
    else
      @leagues = League.where("user_id = " + current_user.id.to_s)
      @teams = Team.all
      render 'new'
    end
  end

  def edit

    @leagues = League.where("user_id = " + current_user.id.to_s)
    @tournament = Tournament.find(params[:id])
    team_ids = [0]
    team_ids += @tournament.teams.collect{|t| t.original_id}
    league_team_ids = [0]
    league_team_ids += @tournament.league.teams.collect{|t| t.original_id}
    @teams = Team.where("id IN (#{league_team_ids.join(",")}) AND id = original_id AND original_id NOT IN (#{team_ids.join(",")})")
    render 'new'
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update(tournament_params)
      flash.now[:notice] = "Your tournament was updated!"
      redirect_to tournament_path(@tournament)
      @tournament.teams.each do |t|
        t.user.follow(@tournament)
        team_members_follow_tournament(@tournament.id, t.id)
      end
    else
      @leagues = League.where("user_id = " + current_user.id.to_s)
      team_ids = [0]
      team_ids += @tournament.teams.collect{|t| t.original_id}
      @teams = Team.where("id = original_id AND original_id NOT IN (#{team_ids.join(",")})")
      render 'new'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start_time, :end_time, :league_id, :tournament_logo, :team_buffer, :ref_buffer, :location_buffer, :collect_team_ids => [])
  end

  def check_user_is_owner
    unless current_user == Tournament.find(params[:id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end

  def check_user_is_league_owner
    unless current_user == League.find(params[:tournament][:league_id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end

  def team_members_follow_tournament(tournament_id, team_id)
    tournament = Tournament.find(tournament_id)
    Team.find(team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(tournament)
      UserMailer.new_follow(user, tournament).deliver
    end
  end
end
