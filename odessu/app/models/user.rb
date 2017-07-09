class User < ApplicationRecord
  has_many :authored_conversations, class_name: "Conversation", foreign_key: 'author_id'
  has_many :received_conversations, class_name: "Conversation", foreign_key: 'receiver_id'
  has_many :sent_messages, class_name: "Message", foreign_key: 'author_id', dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: 'receiver_id', dependent: :destroy
  has_many :orders
  has_one :wish_list
end
