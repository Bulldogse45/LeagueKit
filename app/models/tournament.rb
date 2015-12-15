class Tournament < ActiveRecord::Base


  has_many :teams
  has_many :games
  has_many :locations
  belongs_to :league
  belongs_to :user

end
