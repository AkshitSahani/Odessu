class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from("notifications_#{current_user.id}_channel")
    stream_from("notifications_#{current_user.id}_channel")
  end

  def unsubscribed
  end

  def send_message(data)
    conversation = Conversation.find_by(id: data['conversation_id'])
    if conversation && conversation.participates?(current_user)
      message = current_user.sent_messages.build(body: data['message'], receiver_id: 1)
      message.conversation = conversation
      message.save!
    end
  end
end
