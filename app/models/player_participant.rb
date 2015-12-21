class PlayerParticipant < ActiveRecord::Base

  belongs_to :player
  belongs_to :team

  validates_presence_of :team, {
    message: "You must select a team!"
  }
  validates :player_id, uniqueness: { scope: :team,
    message: "player is already on this team!" }

end
