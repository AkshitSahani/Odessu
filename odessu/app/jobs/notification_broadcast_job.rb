class NotificationBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      del_message = render_message(message)
      ActionCable.server.broadcast "notifications_#{message.receiver_id}_channel",
                                   message: del_message,
                                   conversation_id: message.conversation.id,
                                   message_receiver_id: message.receiver_id

      ActionCable.server.broadcast "notifications_#{message.receiver_id}_channel",
                             notification: render_notification(message),
                             conversation_id: message.conversation.id,
                             message_receiver_id: message.receiver_id
    end

    private

    def render_notification(message)
      NotificationsController.render partial: 'notifications/notification', locals: {message: message}
    end

    def render_message(message)
      MessagesController.render partial: 'messages/message', locals: {message: message}
    end
  end
