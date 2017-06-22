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
                wifi: "The wifi password is: RoomMate2017",
                service: "Which service are you interested in?",
                breakfast: "Starts at 8:00 am and ends at 11:00 am",
                laundry: "Yes, do you want us to pick up your laundry?",
                room: "Your room number is ",
                events: "Yes we do in the third floor",
                swimming: "It opens at 1:00 pm and closes at 9:00 pm",
                attraction: "La sagrada familia! and Park Guell",
                help: ". Can I help you with something else?",
              }

  # CHAT BOT METHODS
  class << self

    # Welcome message
    def welcome(stay, message)

      data = {
        text: MESSAGE[:welcome] + stay.hotel.name + MESSAGE[:help],
        quick_replies:[
          {
              content_type:"text",
              title: "SERVICE",
              payload: "S_PATH",
            },
            {
            content_type: "text",
            title: "WIFI",
            payload:"W_PATH",
            },
            {
              content_type:"text",
              title: "SIGHT SEEING",
              payload: "S_PATH",
            }
          ]
        }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    # Single message answer
    def single_answer(stay, message, input)

      data = {
        text: MESSAGE[input] + MESSAGE[:help],
        quick_replies:[
          {
              content_type:"text",
              title: "SERVICE",
              payload: "S_PATH",
            },
            {
            content_type: "text",
            title: "WIFI",
            payload:"W_PATH",
            },
            {
              content_type:"text",
              title: "SIGHT SEEING",
              payload: "S_PATH",
            }
          ]
        }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    # Method to call for "Services"
    def tree_answer(stay, message, input)

      data = {
        text: MESSAGE[input],
        quick_replies:[
          {
              content_type:"text",
              title: "RESTAURANTS",
              payload: "RESTAURANT_PATH",
            },
            {
              content_type: "text",
              title: "RENT",
              payload:"RENT_PATH",
            },
            {
              content_type:"text",
              title: "SIGHT SEEING",
              payload: "SIGHT_SEEING_PATH",
            }
          ]
        }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    # Method to display the choice ("Restaurant", "Rent", "Sight seeing")
    def display(stay, message, input)

      service_selected = stay.hotel.services.where(category: input)

    end

  end
end




