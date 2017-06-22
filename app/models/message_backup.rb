class Message < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :stay

  validates :content, presence: true
  validates :from, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

  # CHAT BOT METHODS
  class << self

    def bot_welcome(stay, message, statement)
    # Welcome message + Options
    data = {
      text: statement,
      quick_replies:[
        {
          content_type: "text",
          title: "WIFI",
          payload:"WIFI_PATH",
          },
          {
            content_type:"text",
            title: "SERVICE",
            payload: "SERVICE_PATH",
          },
          {
            content_type:"text",
            title: "SIGHTS",
            payload: "SIGHTS_PATH",
          }
        ]
      }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

      def bot_services(stay, message, statement)
    # Welcome message + Options
    data = {
      text: statement,
      quick_replies:[
        {
          content_type: "text",
          title: "RESTAURANTS",
          payload:"REST_PATH",
          },
          {
            content_type:"text",
            title: "LOCA",
            payload: "LOCA_PATH",
          },
          {
            content_type:"text",
            title: "RENTALS",
            payload: "RENT_PATH",
          }
        ]
      }

      # Trigger Welcome message
      message.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    # Easy replies
    def bot_msg(stay, message, statement)
      data = {
        text: statement
      }

      message.reply(data)
      Message.create(content: data, from: "bot", stay: stay)
    end

    def display_slider_service(stay, message)

        service = stay.hotel.services
      # Create a JSON with all the services
      service.each do |s|
        message.typing_on
        reply = message.reply(text: s.title)
        # reply = message.reply(text: s.description)
      end
      # Message.create(content: reply.to_hash, from: "bot", stay: stay)
    end

    def display_slider_sights(stay, message, cat)

        sights = stay.hotel.locations
      # Create a JSON with all the services
      sights.each do |s|
        # message.typing_on
        if s.category == cat
        reply = message.reply(text: s.name )
        end
        # reply = message.reply(text: s.description)
      end
      # Message.create(content: reply.to_hash, from: "bot", stay: stay)
    end

  end
end



