class Message < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :stay

  validates :content, presence: true
  validates :from, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

  # MESSAGE LIST
    MESSAGE = { welcome: "Welcome to the " ,
               wifi: "The wifi password is: RoomMate2017.",
               breakfast: "Starts at 8:00 am and ends at 11:00 am.",
               laundry: "Yes, do you want us to pick up your laundry?",
               room: "Your room number is ",
               events: "Yes we do in the third floor.",
               swimming: "It opens at 1:00 pm and closes at 9:00 pm.",
               attraction: "La sagrada familia! and Park Guell.",
               help: ". Can I help you with something else?",
              }

  # CHAT BOT METHODS
  class << self

    def welcome(stay, message, statement)

      data = {
          attachment:{
            type: "template",
            payload: {
              template_type: "generic",
              elements: [
                 {
                  title: "Welcome to the #{stay.hotel.name}",
                  image_url: "https://room-matehotels.com/images/img/general/slide_inicio/slide_01.jpg",
                  subtitle: "I am here to help enjoy and profit your stay.",
                  default_action: {
                    type: "web_url",
                    url: "www.bellboy.site",
                    messenger_extensions: true,
                    webview_height_ratio: "tall",
                    fallback_url: "www.bellboy.site"
                  },
                  buttons:[
                    {
                      type: "postback",
                      title: "Start Chatting",
                      payload: "START_CHATTING_PAYLOAD"
                    }
                  ]
                }
              ]
            }
          }
        }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)b

    end

  end

end




