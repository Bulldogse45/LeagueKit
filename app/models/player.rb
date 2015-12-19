class Player < ActiveRecord::Base

  validates_presence_of :date_of_birth, :jersey_number, :user_id, :first_name, :last_name

  belongs_to :user
  has_many :player_participants
  has_many :teams, through: :player_participants
end
