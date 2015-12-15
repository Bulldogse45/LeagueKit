class Team < ActiveRecord::Base

  has_many :team_participants
  has_many :tournaments, through: :team_participants
  belongs_to :user
  has_many :player_participants
  has_many :players, through: :player_participants

end
