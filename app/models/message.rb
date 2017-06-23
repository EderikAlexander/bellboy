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
                service: "Here there should be a list template.",
                locations: "Which category are you interested in?",
                breakfast: "Starts at 8:00 am and ends at 11:00 am",
                laundry: "Yes, do you want us to pick up your laundry?",
                room: "Your room number is ",
                events: "Yes we do in the third floor",
                swimming: "It opens at 1:00 pm and closes at 9:00 pm",
                attraction: "La sagrada familia! and Park Guell",
                restart: "Can I help you with something?",
              }

  # CHAT BOT METHODS
  class << self

    def process(message_or_postback)
      # "..." when waiting for message
      message_or_postback.typing_on

      user = User.where(uid: message_or_postback.sender["id"]).first
      stay = user.stays.last  # Get current User (FB user_id) and Stay

      action = message_or_postback.respond_to?(:quick_reply) ? message_or_postback.quick_reply : message_or_postback.payload

      action = message_or_postback.text if not action.present?

      Rails.logger.debug("=== action")
      Rails.logger.debug(action)
      Rails.logger.debug("=== / action")

      Message.welcome(stay, message_or_postback) if action == 'GET_STARTED_PAYLOAD' || action.downcase.strip.include?("restart")
      Message.single_answer_slider(stay, message_or_postback, :service) if action == 'SERVICE_PAYLOAD' || action.downcase.strip.include?("service")
      Message.single_answer(stay, message_or_postback, :wifi) if action == 'WIFI_PAYLOAD' || action.downcase.strip.include?("wifi")
      Message.tree_answer(stay, message_or_postback) if action == 'LOCATION_PAYLOAD' || action.downcase.strip.include?("location")
      Message.display_selection(stay, message_or_postback, "Restaurants") if action == 'RESTAURANT_PAYLOAD' || action.downcase.strip.include?("restaurant")
      Message.display_selection(stay, message_or_postback, "Sights") if action == 'SIGHTS_PAYLOAD' || action.downcase.strip.include?("sight")
      Message.display_selection(stay, message_or_postback, "Rentals") if action == 'RENT_PAYLOAD' || action.downcase.strip.include?("rent")

    end

    # Restart method
    def restart(stay, message_or_postback)

      data = {
        text: MESSAGE[:restart],
        quick_replies:[
          {
              content_type:"text",
              title: "SERVICE",
              payload: "SERVICE_PAYLOAD",
            },
            {
              content_type: "text",
              title: "WIFI",
              payload:"WIFI_PAYLOAD",
            },
            {
              content_type:"text",
              title: "LOCATIONS",
              payload: "LOCATION_PAYLOAD",
            }
          ]
        }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    # Welcome message
    def welcome(stay, message_or_postback)

      data = {
        text: MESSAGE[:welcome] + stay.hotel.name,
        }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

      # Restart method
      Message.restart(stay, message_or_postback)
    end

    # Single message answer
    def single_answer(stay, message_or_postback, input)

      data = {
        text: MESSAGE[input]
        }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

      # Restart method
      Message.restart(stay, message_or_postback)
    end

    # Single message answer
    def single_answer_slider(stay, message_or_postback, input)

      data = {
        text: MESSAGE[input]
        }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    # Method to call for "Services"
    def tree_answer(stay, message_or_postback)

      data = {
        text: MESSAGE[:locations],
        quick_replies:[
          {
              content_type:"text",
              title: "RESTAURANTS",
              payload: "RESTAURANT_PAYLOAD",
            },
            {
              content_type: "text",
              title: "RENT",
              payload:"RENT_PAYLOAD",
            },
            {
              content_type:"text",
              title: "SIGHT SEEING",
              payload: "SIGHTS_PAYLOAD",
            }
          ]
        }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    # Method to display the choice ("Restaurant", "Rent", "Sight seeing")
    def display_selection(stay, message_or_postback, category)

      selection = stay.hotel.locations.where(category: category)

      selection.each do |selected|
        # TODO CARROUSEL
        message_or_postback.reply(text: selected.name)
      end

    end

  end
end




