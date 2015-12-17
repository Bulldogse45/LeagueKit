class Team < ActiveRecord::Base

  acts_as_followable
  has_many :announces, as: :announcable

  belongs_to :tournament
  belongs_to :user
  has_many :player_participants
  has_many :players, through: :player_participants

  def display_name
    if self.tournament
      "#{self.name}-#{self.tournament.name}"
    else
      "#{self.name}-main"
    end
  end

end
