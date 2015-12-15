class Tournament < ActiveRecord::Base

  has_many :team_participants
  has_many :teams, through: :team_participants
  has_many :games
  has_many :locations
  belongs_to :league
  belongs_to :user

end
