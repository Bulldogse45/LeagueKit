class League < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable

  belongs_to :user
  has_many :tournaments

end
