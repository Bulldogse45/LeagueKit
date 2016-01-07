class TeamsController < ApplicationController
  before_action :require_user
  before_action :check_user_is_owner, only: [:edit, :update]
  before_action :check_user_is_tournament_owner, only: [:clone]

  def index
    @tournament_teams = []
    Team.joins(:tournament).where("teams.id != original_id AND tournaments.start_time > '#{(Time.now-72.hours).to_s}'").order("tournaments.start_time ASC").each do |t|
      if current_user.following?(t)
        @tournament_teams << t
      end
    end
    @teams =[]
    Team.where("teams.id = original_id").each do |t|
      if current_user.following?(t)
        @teams << t
      end
    end

  end

  def new
    @team = Team.new
  end

  def search
    if params[:player_id]
      @player=Player.find(params[:player_id])
    elsif params[:league_id]
      @league=League.find(params[:league_id])
      @leagues = League.where("user_id = #{current_user.id}")
    end
  end

  def league_add
    league = League.find(params[:league_id])
    team = Team.find(params[:team_id])
    if LeagueTy.where("team_id = #{team.id} AND league_id = #{league.id}").length == 0
      LeagueTy.create(team_id:team.original_id, league_id:league.id)
      flash[:success] = "#{team.name} was successfully added to #{league.name}"
      redirect_to league
    else
      flash[:alert] = "#{team.name} is already part of #{league.name}"
      redirect_to :back
    end
  end

  def search_results
    if params[:player_id]
      @player=Player.find(params[:player_id])
    end
    if params[:league_id]
      @league=League.find(params[:league_id])
    end
    @teams = Team.search(params[:search])
    @tournament_teams = []
  end

  def all
    if params[:tournament_id] && Tournament.find(params[:tournament_id]).user == current_user
      @tournament = Tournament.find(params[:tournament_id])
      teams = []
      @tournament.league.teams.each do |t|
        teams << Team.find(t.original_id)
      end
      tournament_teams = []
      @tournament.teams.each do |t|
        tournament_teams << Team.find(t.original_id)
      end
      @teams = teams - tournament_teams
    elsif params[:league_id] && League.find(params[:league_id]).user == current_user
      @league = League.find(params[:league_id])
      team_ids = [0]
      team_ids += @league.league_ties.teams.collect{|t| t.original_id}
      @teams = Team.where("id = original_id AND original_id NOT IN (#{team_ids.join(",")})")
    else
      flash[:warning] = "You are not permitted to view that page."
      redirect_to root_path
    end

    @team = Team.new
  end

  def show
    @team = Team.find(params['id'])
    @announces = @team.announces.page(params['page']).per(5)
  end

  def clone
    @team = Team.new(team_params)
    @team.name = Team.find(params['team']['original_id'].to_i).name
    @team.user = Team.find(params['team']['original_id'].to_i).user
    if @team.save
      current_user.follow(@team)
      Team.find(@team.original_id).players.each do |p|
        @team.players << p
      end
      team_members_follow_tournament(@team.tournament_id, @team.id)
      redirect_to @team.tournament
    else
      flash[:alert] = @team.errors
      redirect_back_or_default root_path
    end
  end

  def edit
    @team = Team.find(params[:id])
    render 'new'
  end

  def update
    @team = Team.find(params[:id])
    original_coach = @team.user
    if username_lookup(params[:team][:username])
      @team.user = User.where("username = '#{params[:team].delete(:username)}'").first
      if @team.update(team_params)
        new_coach = @team.user
        new_coach.follow(@team)
        message = Message.create(to_users_list:new_coach.username,from_user_id:original_coach.id, subject:"You are now the coach of #{@team.name}", content:"You were made the coach of #{@team.name}.  This decision was made by the user #{original_coach.username}.  If there are any questions you can reply to this message.  Thanks!")
        message.to_users_ids.split(",").each do |u|
          MessageRead.create(user_id:u.to_i,message_id:message.id)
          UserMailer.message_notification(User.find(u.to_i), message).deliver
        end
        flash[:notice] = "Your team was updated!"
        redirect_to team_path(@team)
      else
        flash.now[:alert] = @team.errors
        render 'new'
      end
    else
      params[:team].delete(:username)
      flash.now[:alert] = "That is not a user in our database!"
      render 'new'
    end
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      @team.update(original_id:@team.id)
      current_user.follow(@team)
      redirect_to @team
    else
      render 'new'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.games.each do |g|
      g.destroy
    end
    @team.destroy
    redirect_to :back
  end

  private

  def team_params
    params.require(:team).permit(:name, :original_id, :tournament_id, :team_logo, :username )
  end

  def team_members_follow_tournament(tournament_id, team_id)
    tournament = Tournament.find(tournament_id)
    Team.find(team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(tournament)
      UserMailer.new_follow(user, tournament).deliver
    end
  end

  def check_user_is_owner
    unless current_user == Team.find(params['id']).user
      flash[:alert]= "You must be the Team's owner to access this page!"
      redirect_to root_path
    end
  end

  def check_user_is_tournament_owner
    unless current_user == Tournament.find(params[:team][:tournament_id]).user
      flash[:alert]= "You must be the Tournament's owner to access this page!"
      redirect_to root_path
    end
  end

  def username_lookup(username)
    User.where("username = '#{username.strip}'").first
  end
end
