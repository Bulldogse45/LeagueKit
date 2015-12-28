class Message < ActiveRecord::Base


  def from
    User.find(self.from_user_id)
  end

  def to
    User.find(self.to_user_id)
  end

end
