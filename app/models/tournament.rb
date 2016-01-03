class Tournament < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name, :start_time, :end_time

  has_many :teams
  has_many :games
  has_many :locations
  belongs_to :league
  belongs_to :user
  has_many :referees
  has_many :users, through: :referees
  attachment :tournament_logo, content_type: ["image/jpeg", "image/png", "image/gif"]

  def coaches
    coaches = []
    self.teams.each do |t|
      coaches << t.user
    end
    coaches
  end
end
