class Player < ActiveRecord::Base

  belongs_to :user
  has_many :team_participants, through: :player_participants

end
