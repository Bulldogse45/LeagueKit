class MessageSerializer < ActiveModel::Serializer
  attributes :id, :to_user_id, :from_user_id, :subject, :content, :message_status_id
end
