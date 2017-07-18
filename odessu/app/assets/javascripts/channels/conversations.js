$(document).ready( function() {

  let messages_to_bottom = () => messages.scrollTop(messages.prop("scrollHeight"));
  var messages = $('#conversation-body');

  if ($('#current-user').size() > 0) {
    App.personal_chat = App.cable.subscriptions.create({
      channel: "NotificationsChannel"
    }, {
    connected() {},
      // Called when the subscription is ready for use on the server

    disconnected() {},
      // Called when the subscription has been terminated by the server

    received(data) {
      console.log('Received data');

      if ((messages.size() > 0) && (messages.data('conversation-id') === data['conversation_id'])) {
        messages.append(data['message']);
        return messages_to_bottom();
      }
      else {

        if ($('#conversations').size() > 0) { $.getScript('/conversations'); }

        if (data['notification']) {
          return $('body').append(data['notification']);
        }
      }
    },

    send_message(message, conversation_id, message_receiver_id) {
      console.log('message sent!');
      return this.perform('send_message', {message, conversation_id, message_receiver_id});
    }
  }
    );
  }

  $(document).on('click', '#notification .close', function() {
    return $(this).parents('#notification').fadeOut(1000);
  });

  if (messages.length > 0) {
    messages_to_bottom();
    return $('#new_message').submit(function(e) {
      let $this = $(this);
      let textarea = $this.find('#message_body');
      if ($.trim(textarea.val()).length > 0) {
        App.personal_chat.send_message(textarea.val(), $this.find('#conversation_id').val(), $this.find('#message_receiver_id').val());
        console.log('form submitted and data being sent.');
        console.log(textarea.val());
        console.log($this.find('#conversation_id').val());
        console.log($this.find('#message_receiver_id').val());
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });
  }
});
