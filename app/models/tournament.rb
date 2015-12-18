class Tournament < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name, :start_time, :end_time

  has_many :teams
  has_many :games
  has_many :locations
  belongs_to :league
  belongs_to :user

end
