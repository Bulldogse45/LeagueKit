class League < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name

  belongs_to :user
  attachment :league_logo, content_type: ["image/jpeg", "image/png", "image/gif"]
  has_many :tournaments
  has_many :locations
  has_many :league_ties
  has_many :teams, through: :league_ties

end
