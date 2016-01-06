class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :teams
  has_many :announces, as: :announcable
  has_many :referees
  has_many :users, through: :referees
  belongs_to :location
  acts_as_followable
  validates_presence_of :home_team_id, :begin_time, :away_team_id
  before_save :check_all

  def name
    return "#{self.tournament.name} - Game #{self.tournament.games.index(self) + 1}"
  end

  def user
    return self.tournament.user
  end

  def list_referees=(referee_ids)
    self.referees = []
    referee_ids.each do |r|
      if r != ""
        referee = Referee.create!(user_id:r.to_i)
        self.referees << referee
      end
    end
  end

  def list_referees
    referees = []
    self.referees.each do |r|
      referees << User.find(r.user_id)
    end
    referees
  end

  def home_team
    Team.find(self.home_team_id)
  end

  def away_team
    Team.find(self.away_team_id)
  end

  def ref_check
    ref_not_available = []
    self.referees.each do |r|
      r.user.referees.each do |g|
        if g.game && g.game != self && self.begin_time <= g.game.begin_time + self.tournament.ref_buffer.minutes && self.begin_time >= g.game.begin_time - self.tournament.ref_buffer.minutes
          ref_not_available << [r, g.game.begin_time]
        end
      end
    end
    if ref_not_available.length > 0
      ref_not_available.each do |r|
        errors.add(:list_referees, "#{r[0].user.username} is unavailable for this game because they have a game at #{r[1].strftime("%l:%M %p")}.")
      end
      @checker = false
    end
  end

  def location_check
    if self.location && self.tournament.location_buffer
      location_not_available = []
      games = self.location.games - [self]
      games.each do |g|
        if self.begin_time <= g.begin_time + self.tournament.location_buffer.minutes && self.begin_time >= g.begin_time - self.tournament.location_buffer.minutes
          location_not_available << [self.location.name, g.begin_time]
        end
      end
      if location_not_available.length > 0
        location_not_available.each do |r|
          errors.add(:location_id, "#{r[0]} is unavailable for this game because a game is already scheduled for #{r[1].strftime("%l:%M %p")}.")
        end
        @checker = false
      end
    end
  end

  def playing_self_check
    if self.home_team_id == self.away_team_id
      errors.add(:away_team_id, "A team cannot play itself.")
      @checker = false
    end
  end

  def home_team_check
    if self.tournament.team_buffer
      team_not_available = []
      games = self.home_team.games - [self]
      games.each do |g|
        if self.begin_time <= g.begin_time + self.tournament.team_buffer.minutes && self.begin_time >= g.begin_time - self.tournament.team_buffer.minutes
          team_not_available << [self.home_team.name, g.begin_time]
        end
      end
      if team_not_available.length > 0
        team_not_available.each do |r|
          errors.add(:home_team_id, "#{r[0]} are unavailable for this game because they have a game scheduled for #{r[1].strftime("%l:%M %p")}.")
        end
        @checker = false
      end
    end
  end

  def away_team_check
    if self.tournament.team_buffer
      team_not_available = []
      games = self.away_team.games - [self]
      games.each do |g|
        if self.begin_time <= g.begin_time + self.tournament.team_buffer.minutes && self.begin_time >= g.begin_time - self.tournament.team_buffer.minutes
          team_not_available << [self.away_team.name, g.begin_time]
        end
      end
      if team_not_available.length > 0
        team_not_available.each do |r|
          errors.add(:away_team_id, "#{r[0]} are unavailable for this game because they have a game scheduled for #{r[1].strftime("%l:%M %p")}.")
        end
        @checker = false
      end
    end
  end

  def check_coach_not_ref
    ref_not_available = []
    self.referees.each do |r|
      if r.user == self.home_team.user
        ref_not_available << [r.user.full_name, self.home_team.name]
      elsif r.user == self.away_team.user
        ref_not_available << [r.user.full_name, self.away_team.name]
      end
    end
    if ref_not_available.length > 0
      ref_not_available.each do |r|
        errors.add(:list_referees, "#{r[0]} is unavailable for this game because they are the coach of #{r[1]}.")
      end
      @checker = false
    end

  end

  def check_all
    @checker = true
      home_team_check
      away_team_check
      location_check
      ref_check
      playing_self_check
      check_coach_not_ref
    @checker
  end

end
