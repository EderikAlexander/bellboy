require 'facebook/messenger'

include Facebook::Messenger


Bot.on :message do |message|
  message.typing_on

  # Get current User (FB user_id) and Stay
  user = User.where(uid: message.sender["id"]).first
  stay = user.stays.last

  # Save message from user
  Message.create(content: message, from: "user", stay: stay)

  # First message?
  first_time = !stay.messages.where(from: "bot").any?
  # first_time = true

  # Bot predefined answers
  Message.welcome(stay, message) if first_time

  # Simple answer to question
  Message.single_answer(stay, message, :wifi) if message.quick_reply == "W_PATH"  # || message.text.downcase.strip.include?("wifi")

  # Tree answer to question (service)
  Message.tree_answer(stay, message, :service) if message.quick_reply == "S_PATH"  # || message.text.downcase.strip.include?("service")

  # Display option
  # Restaurant
  Message.display(stay, message, "restaurant") if message.quick_reply == "RESTAURANT_PATH"  # || message.text.downcase.strip.include?("restaurant")
  Message.display(stay, message, "rent") if message.quick_reply == "RENT_PATH"  # || message.text.downcase.strip.include?("rent")
  Message.display(stay, message, "sight_seeing") if message.quick_reply == "SIGHT_SEEING_PATH"  # || message.text.downcase.strip.include?("sight")

end
