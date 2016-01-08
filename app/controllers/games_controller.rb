class GamesController < ApplicationController

  before_action :check_user_is_tournament_owner, only: [:edit, :update, :create, :destroy]
  before_action :require_user

  def index
    all_ids = []
    current_user.players.each do |p|
      p.teams.each do |t|
        all_ids << t.id.to_s
      end
    end
    current_user.teams.each do |t|
      all_ids << t.id.to_s
    end
    team_ids = "(" + all_ids.join(",") +")"
    time_range = (Time.now.midnight - 1.day)..Time.now.midnight
    @games = Game.where("begin_time > '#{Time.now - 1.day}' AND (home_team_id IN #{team_ids} OR away_team_id IN #{team_ids})").order("begin_time ASC")
  end

  def new
    @referees = Tournament.find(params[:tournament_id]).referees.collect{|r| r.user}
    @game = Game.new
    if params[:tournament_id]
      @game.tournament = Tournament.find(params[:tournament_id])
    else
      flash.now[:alert] = "You must create a tournament to add a game"
      redirect_to tournaments_path
    end
    @locations = @game.tournament.league.locations
    @teams = @game.tournament.teams
  end

  def show
    @game = Game.find(params['id'])
    @home_team = Team.find(@game.home_team_id)
    @away_team = Team.find(@game.away_team_id)
  end

  def edit
    @game = Game.find(params[:id])
    @referees = []
    @game.tournament.referees.each do |r|
      @referees << User.find(r.user_id)
    end
    @locations = @game.tournament.league.locations
    @teams = @game.tournament.teams

    render 'new'
  end

  def update
    @game = Game.find(params[:id])
    @locations = @game.tournament.league.locations
    @teams = @game.tournament.teams
    @referees = @game.tournament.referees.collect{|r| r.user}
    if @game.update(game_params)
      flash.now[:notice] = "Your game was updated!"
      team_members_follow_game(@game)
      create_announce
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      current_user.follow(@game)
      team_members_follow_game(@game)
      redirect_to @game
    else
      @locations = @game.tournament.league.locations
      @teams = @game.tournament.teams
      @referees = @game.tournament.referees.collect{|r| r.user}
      render 'new'
    end
  end

  def destroy
    @game = Game.find(params[:id])
    tournament = @game.tournament
    create_announce_cancelled
    if @game.destroy
      flash.now[:notice] = "Your game was updated!"
      redirect_to tournament_path(tournament)
    else
      flash.now[:alert] = @game.errors
      render 'new'
    end
  end

  private

  def game_params
    params.require(:game).permit(:home_team_id, :away_team_id, :tournament_id, :location_id, :begin_time, :list_referees => [] )
  end

  def team_members_follow_game(game)
    unless game.home_team.user.following?(game)
      game.home_team.user.follow(game)
      UserMailer.new_follow(game.home_team.user, game).deliver
    end
    unless game.away_team.user.following?(game)
      game.away_team.user.follow(game)
      UserMailer.new_follow(game.away_team.user, game).deliver
    end
    game.home_team.players.each do |p|
      user = p.user
      unless user.following?(game)
        user.follow(game)
        UserMailer.new_follow(user, game).deliver
      end
    end
    game.away_team.players.each do |p|
      user = p.user
      unless user.following?(game)
        user.follow(game)
        UserMailer.new_follow(user, game).deliver
      end
    end
  end

  def check_user_is_tournament_owner
    if params[:game]
      unless current_user == Tournament.find(params[:game][:tournament_id]).user
        flash.now[:alert]= "You must be the Tournament's owner to access this page!"
        redirect_to root_path
      end
    else
      unless current_user == Game.find(params[:id]).tournament.user
        flash.now[:alert]= "You must be the Tournament's owner to access this page!"
        redirect_to root_path
      end
    end
  end

  def create_announce
    @announce = Announce.new
    @announce.announcable = @game;
    @announce.content = "#{@announce.announcable.name} was updated!  The game is now on #{@game.begin_time.strftime("%b %e, at %l:%M %p")} between #{@game.home_team.name} vs #{@game.away_team.name}.  "
    if @game.location_id
      @announce.content += "The game will be played at #{@game.location.name}"
    end
    if @announce.save
      AnnouncementViewed.create(user_id:current_user.id, announce_id:@announce.id, viewed:false)
      flash.now[:notice] = "Announcement successful!"
      @game.followers.each do |f|
        UserMailer.announcement_notification(f, @announce).deliver
      end
    else
      flash.now[:alert] = "There was an error and an announcement was not sent out!  Please report to MyLeagueKit@gmail.com.  Thank you!"
    end
  end

  def create_announce_cancelled
    @announce = Announce.new
    @announce.announcable = @game.tournament;
    @announce.content = "Your Game on #{@game.begin_time.strftime("%b %e, at %l:%M %p")} between #{@game.home_team.name} vs #{@game.away_team.name} was Cancelled!"
    if @announce.save
      AnnouncementViewed.create(user_id:current_user.id, announce_id:@announce.id, viewed:false)
      flash.now[:notice] = "Announcement successful!"
      @game.followers.each do |f|
        UserMailer.announcement_notification(f, @announce).deliver
      end
    else
      flash.now[:alert] = "There was an error and an announcement was not sent out!  Please report to MyLeagueKit@gmail.com.  Thank you!"
    end
  end
end
