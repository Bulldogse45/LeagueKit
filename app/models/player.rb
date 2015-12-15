class Player < ActiveRecord::Base

  belongs_to :user
  has_many :player_participants
  has_many :team_participants, through: :player_participants
  has_many :teams, through: :player_participants  
end
