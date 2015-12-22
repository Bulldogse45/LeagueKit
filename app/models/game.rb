class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :teams
  has_many :announces, as: :announcable
  acts_as_followable

  def name
    return "#{self.tournament.name} - Game #{self.tournament.games.index(self) + 1}"
  end

  def user
    return self.tournament.user
  end

end
