class League < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name

  belongs_to :user
  has_many :tournaments

end
