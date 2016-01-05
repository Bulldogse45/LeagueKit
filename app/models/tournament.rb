class Tournament < ActiveRecord::Base
  has_many :announces, as: :announcable
  acts_as_followable
  validates_presence_of :name, :start_time, :end_time, :league_id

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


  def collect_team_ids=(arr)
    tournament_id = self.id
    arr.each do |t|
      if t != ""
        team2 = Team.find(t.to_i)
        team = Team.new()
        team.original_id = team2.id
        team.name = team2.name
        team.user = team2.user
        if team.save!
          team2.players.each do |p|
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

  def team_members_follow_tournament(tournament_id, team_id)
    tournament = Tournament.find(tournament_id)
    Team.find(team_id).players.each do |p|
      user = User.find(p.user_id)
      user.follow(tournament)
      UserMailer.new_follow(user, tournament).deliver
    end
  end
end
