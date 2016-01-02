class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :address_line_1, :address_line_2, :city, :state, :zip, :notes
end
