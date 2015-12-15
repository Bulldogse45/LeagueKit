class PlayerParticipant < ActiveRecord::Base

  belongs_to :player
  belongs_to :team_participant
  belongs_to :team
  
end
