class TeamParticipant < ActiveRecord::Base

  belongs_to :team
  belongs_to :tournament
  has_many :player_participants
  has_many :players, through: :player_participants

end
