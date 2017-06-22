require 'facebook/messenger'

include Facebook::Messenger


Bot.on :message do |message|
  message.typing_on

  # Get current User (FB user_id) and Stay
  user = User.where(uid: message.sender["id"]).first
  stay = user.stays.last

  # First message?
  first_time = !stay.messages.where(from: "bot").any?
  first_time = true

  # Bot predefined answers
  Message.welcome(stay, message) if first_time

end
