class Tournament < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name, :start_time, :end_time, :league_id
  before_save :end_after_begin, :begins_in_future

  has_many :teams
  has_many :games
  has_many :locations
  belongs_to :league
  belongs_to :user
  has_many :referees
  has_many :users, through: :referees
  has_many :coaches, :through => :teams, :source => :user
  attachment :tournament_logo, content_type: ["image/jpeg", "image/png", "image/gif"]


  def collect_team_ids=(arr)
    tournament_id = self.id
    arr.each do |t|
      if t != "" && !self.teams.collect{|team| team.original_id}.include?(Team.find(t).original_id)
        team2 = Team.find(t.to_i)
        team = Team.new()
        team.original_id = team2.id
        team.name = team2.name
        team.user = team2.user
        if team.save!
          team.user.follow(team)
          team2.players.each do |p|
            p.user.follow(team)
            team.players << p
          end
        end
        self.teams << team
      end
    end
  end

  def collect_team_ids

  end

  private

  def end_after_begin
    if self.end_time < self.start_time
      errors.add(:end_time, "A tournament cannot end before it begins.")
      false
    else
      true
    end
  end

  def begins_in_future
    if Time.now - 12.hours > self.start_time
      errors.add(:start_time, "Currently tournaments must be created within 12 hours of the start time.")
      false
    else
      true
    end
  end
end
