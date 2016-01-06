class User < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  acts_as_follower

  acts_as_authentic do |c|
    c.login_field = :email
  end

  validates_presence_of :first_name, :last_name, :username
  validates :username, uniqueness: true

  has_many :leagues
  has_many :message_reads
  has_many :teams
  has_many :games
  has_many :players
  has_many :tournaments
  has_many :referees
  has_many :tournaments, through: :referees
  has_many :games, through: :referees
  has_many :to_users
  has_many :messages, through: :to_users

  def full_name
    suffix = ""
    if self.suffix != nil
      suffix = ", #{self.suffix}"
    end
    return "#{self.first_name} #{self.last_name}#{suffix}"
  end

end
