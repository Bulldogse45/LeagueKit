class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :teams
  has_many :announces, as: :announcable
  has_many :referees
  has_many :users, through: :referees
  belongs_to :location
  acts_as_followable
  validates_presence_of :home_team_id, :begin_time, :away_team_id
  before_save :location_check, :ref_check

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
        if g.game && self.begin_time <= g.game.begin_time + self.tournament.ref_buffer.minutes && self.begin_time >= g.game.begin_time - self.tournament.ref_buffer.minutes
          ref_not_available << [r, g.game.begin_time]
        end
      end
    end
    if ref_not_available.length > 0
      ref_not_available.each do |r|
        errors.add(:list_referees, "#{r[0].user.username} is unavailable for this game because they have a game at #{r[1].strftime("%l:%M %p")}.")
      end
      false
    else
      true
    end
  end

  def location_check
    location_not_available = []
    self.location.games.each do |g|
      if self.begin_time <= g.begin_time + self.tournament.location_buffer.minutes && self.begin_time >= g.begin_time - self.tournament.location_buffer.minutes
        location_not_available << [self.location.name, g.begin_time]
      end
    end
    if location_not_available.length > 0
      location_not_available.each do |r|
        errors.add(:location_id, "#{r[0]} is unavailable for this game because a game is already scheduled for #{r[1].strftime("%l:%M %p")}.")
      end
      false
    else
      true
    end
  end

end
