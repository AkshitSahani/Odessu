class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :author, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true

  after_create_commit do
    conversation.touch
    NotificationBroadcastJob.perform_later(self)
  end
end
