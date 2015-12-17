class Game < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable

end
