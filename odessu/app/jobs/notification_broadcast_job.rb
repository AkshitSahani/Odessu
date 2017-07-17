class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    message = render_message(message)
    ActionCable.server.broadcast "notifications_1_channel",
                                 message: message,
                                 conversation_id: message.conversation.id,
                                 receiver_id: 1

    ActionCable.server.broadcast "notifications_1_channel",
                           notification: render_notification(message),
                           conversation_id: message.conversation.id,
                           receiver_id: 1
  end

  private

  def render_notification(message)
    NotificationsController.render partial: 'notifications/notification', locals: {message: message}
  end

  def render_message(message)
    MessagesController.render partial: 'messages/message',
                                      locals: {message: message}
  end
end
