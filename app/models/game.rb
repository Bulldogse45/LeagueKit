class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :teams
  has_many :announces, as: :announcable
  has_many :referees
  has_many :users, through: :referees
  acts_as_followable

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

end
