class Location < ActiveRecord::Base

  belongs_to :league
  has_many :games

  def google_address
    address = "#{self.address_line_1}+#{self.address_line_2}+#{self.city},#{state}"
  end

end
