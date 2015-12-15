class Team < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :user
  has_many :player_participants
  has_many :players, through: :player_participants

end
