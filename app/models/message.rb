class Message < ActiveRecord::Base
  has_many :message_reads
  has_many :to_users
  has_many :users, through: :to_users


  def from
    User.find(self.from_user_id)
  end

  def to_users_list=(args)
    args.split(",").each do |u|
      self.to_users << ToUser.create(user_id:username_lookup(u).id, message_id:self.id)
    end
  end

  def to_users_list
    to_users = self.to_users.collect{|u| u.user.username}
    to_users.join(", ")
  end

  def to_users_ids
    to_users = []
    self.to_users.each do |u|
      to_users << u.user.id.to_s
    end
    to_users.join(",")
  end

  def username_lookup(username)
    User.where("username = '#{username.strip}'").first
  end

end
