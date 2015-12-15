class User < ActiveRecord::Base

  acts_as_authentic

  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :zip, :phone1

  has_many :leagues
  has_many :teams
  has_many :games
  has_many :players
  has_many :tournaments

end
