# require 'facebook/messenger'

# include Facebook::Messenger


# # MESSAGE LIST
# MESSAGE = { welcome: "Welcome to the " ,
#            wifi: "The wifi password is: RoomMate2017.",
#            breakfast: "Starts at 8:00 am and ends at 11:00 am.",
#            laundry: "Yes, do you want us to pick up your laundry?",
#            room: "Your room number is ",
#            events: "Yes we do in the third floor.",
#            swimming: "It opens at 1:00 pm and closes at 9:00 pm.",
#            attraction: "La sagrada familia! and Park Guell.",
#            help: "Can I help you with something else?",
#            full_stop: ". ",
#           }

# # POSTBACK TO PAYLOADS
# # Bot.on :postback do |postback|

# #   # WIFI POSTBACK
# #   if postback.payload == 'WIFI_PATH'
# #     Message.bot_msg(stay, postback, MESSAGE[:wifi] + MESSAGE[:help] )
# #   end

# #   # LAUNDRY POSTBACK
# #   if postback.payload == 'LAUNDRY_PATH'
# #     Message.bot_msg(stay, postback, MESSAGE[:laundry] + MESSAGE[:help] )
# #   end
# # end


# # WELCOME MESSAGE + OPTIONS
# Bot.on :message do |message|
#   message.typing_on
#   # Get current User (FB user_id) and Stay
#   user = User.where(uid: message.sender["id"]).first
#   stay = user.stays.last


#   if message.quick_reply

#     if message.quick_reply == "WIFI_PATH" || message.text.downcase.strip.include?("wifi")
#       Message.bot_msg(stay, message, MESSAGE[:wifi] + MESSAGE[:help] )
#     end
#     if message.quick_reply == "SERVICE_PATH" || message.text.downcase.strip.include?("service")
#       Message.display_slider_service(stay, message)
#     end
#     if message.quick_reply == "SIGHTS_PATH" || message.text.downcase.strip.include?("sight")
#       Message.bot_services(stay, message, "Choose your category")
#     end
#     if message.quick_reply == "REST_PATH" || message.text.downcase.strip.include?("restaurants")
#       Message.display_slider_sights(stay, message, "Restaurants")
#     end
#     if message.quick_reply == "LOCA_PATH" || message.text.downcase.strip.include?("loca")
#       Message.display_slider_sights(stay, message, "sight seeing")
#     end
#     if message.quick_reply == "RENT_PATH" || message.text.downcase.strip.include?("rentals")
#       Message.display_slider_sights(stay, message, "Rentals")
#     end
#   end

#   # First message?
#   first_time = !stay.messages.where(from: "bot").any?
#   first_time = true if Rails.env.development?

#   # Bot predefined answers
#   Message.bot_welcome(stay, message, stay.hotel.name) if first_time
#   # Message.bot_welcome(stay, message, MESSAGE[:welcome] + stay.hotel.name + MESSAGE[:full_stop] + MESSAGE[:help]) if first_time
# end

# # Bot.on :postback do |postback|
# #   postback.sender    # => { 'id' => '1008372609250235' }
# #   postback.recipient # => { 'id' => '2015573629214912' }
# #   postback.sent_at   # => 2016-04-22 21:30:36 +0200
# #   postback.payload   # => 'EXTERMINATE'
# #   if postback.payload == 'EXTERMINATE'
# #     postback.reply(text: "Human #{postback.recipient} marked for extermination")
# #   end
# # end

# # Bot.on :message do |message|
# # message.typing_on
# # message.reply(
# #   attachment: {
# #     type: 'template',
# #     payload: {
# #       template_type: 'button',
# #       text: 'Human, do you like me?',
# #       buttons: [
# #         { type: 'postback', title: 'Yes', payload: 'HARMLESS' },
# #         { type: 'postback', title: 'No', payload: 'EXTERMINATE' }
# #       ]
# #     }
# #   }
# # )
# # end

# # STUPID CONVERSATION

# # Bot.on :message do |message|

# #   # Get current User (FB user_id) and Stay
# #   user = User.where(uid: message.sender["id"]).first
# #   stay = user.stays.last

# #   # First message?
# #   stay.messages.where(from: "bot").count > 0 ? first_time = false : first_time = true

# #   # # Bot predefined answers
# #   Message.bot_msg(stay, message, MESSAGE[:wifi] + MESSAGE[:help] )   if message.text.downcase.strip.include?("wifi")
# #   Message.bot_msg(stay, message, MESSAGE[:breakfast] + MESSAGE[:help] )  if message.text.downcase.strip.include?("breakfast")
# #   Message.bot_msg(stay, message, MESSAGE[:laundry] + MESSAGE[:help] )    if message.text.downcase.strip.include?("laundry")
# #   Message.bot_msg(stay, message, MESSAGE[:room] + stay.hotel.rooms.first.number.to_s + MESSAGE[:full_stop] + MESSAGE[:help] )       if message.text.downcase.strip.include?("room")
# #   Message.bot_msg(stay, message, MESSAGE[:events] + MESSAGE[:help] )     if message.text.downcase.strip.include?("event")
# #   Message.bot_msg(stay, message, MESSAGE[:swimming] + MESSAGE[:help] )   if message.text.downcase.strip.include?("swimming")
# #   Message.bot_msg(stay, message, MESSAGE[:attraction] + MESSAGE[:help] ) if message.text.downcase.strip.include?("attraction")

# #   # # Services
# #   Message.display_slider(stay, message) if message.text.downcase.strip.include?("service")
# #   # Locations
# # end
