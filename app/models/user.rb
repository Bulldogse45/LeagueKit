class User < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  acts_as_follower

  acts_as_authentic

  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :zip, :phone1

  has_many :leagues
  has_many :teams
  has_many :games
  has_many :players
  has_many :tournaments
  has_many :referees
  has_many :tournaments, through: :referees
  has_many :games, through: :referees

  def full_name
    return "#{self.last_name}, #{self.first_name}"
  end

end
