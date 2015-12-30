class GamesController < ApplicationController

  before_action :check_user_is_tournament_owner, only: [:edit, :update, :create]
  before_action :require_user

  def index
    team_ids = "(" + current_user.teams.collect{|t| t.id}.join(",") +")"
    @games = Game.where("home_team_id IN #{team_ids} OR away_team_id IN #{team_ids}"  )
  end

  def new
    @referees = []
    Tournament.find(params[:tournament_id]).referees.each do |r|
      @referees << User.find(r.user_id)
    end
    @game = Game.new
    if params[:tournament_id]
      @game.tournament = Tournament.find(params[:tournament_id])
    else
      flash[:alert] = "You must create a tournament to add a game"
      redirect_to tournaments_path
    end
    @locations = []
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
    @locations = []
    @teams = @game.tournament.teams

    render 'new'
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      flash[:notice] = "Your game was updated!"
      team_members_follow_game(@game)
      create_announce
      redirect_to game_path(@game)
    else
      flash[:alert] = @game.errors
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
      render 'new'
    end
  end

  private

  def game_params
    params.require(:game).permit(:home_team_id, :away_team_id, :tournament_id, :location_id, :begin_time, :list_referees => [] )
  end

  def team_members_follow_game(game)
    Team.find(game.home_team_id).players.each do |p|
      user = User.find(p.user_id)
      if !user.following?(game)
        user.follow(game)
        UserMailer.new_follow(user, game).deliver
      end
    end
    Team.find(game.away_team_id).players.each do |p|
      user = User.find(p.user_id)
      if !user.following?(game)
        user.follow(game)
        UserMailer.new_follow(user, game).deliver
      end
    end
  end

  def check_user_is_tournament_owner
    if params[:game]
      unless current_user == Tournament.find(params[:game][:tournament_id]).user
        flash[:alert]= "You must be the Tournament's owner to access this page!"
        redirect_to root_path
      end
    else
      unless current_user == Game.find(params[:id]).tournament.user
        flash[:alert]= "You must be the Tournament's owner to access this page!"
        redirect_to root_path
      end
    end
  end

  def create_announce
    @announce = Announce.new
    @announce.announcable = @game;
    @announce.content = "#{@announce.announcable.name} was updated!  The game is now on #{@game.begin_time.strftime("%b %e, at %l:%M %p")} between #{@game.home_team.name} vs #{@game.away_team.name}.  "
    if @game.location_id
      @announce.content += "The game will be played at #{game.location.name}"
    end
    if @announce.save
      AnnouncementViewed.create(user_id:current_user.id, announce_id:@announce.id, viewed:false)
      flash[:notice] = "Announcement successful!"
      @game.followers.each do |f|
        UserMailer.announcement_notification(f, @announce).deliver
      end
    else
      flash[:alert] = "There was an error and an announcement was not sent out!  Please report to MyLeagueKit@gmail.com.  Thank you!"
    end
  end


end
