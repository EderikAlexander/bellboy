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

      # # Get current User (FB user_id) and Stay
      user = User.all.where(uid: message_or_postback.sender["id"]).first

# #################################################################################

# ##########.            THIS SHOULD BE MADE BY THE HOTEL               ###########
# ##########       AUTOMATICALLY WHEN THE EMAIL SEND TO THE GUEST       ###########

# #################################################################################


      # # Create Hotel and Stays for the user (to be able to chat with the bot)
      # hotel = Hotel.all.where( name: "Room Mate Emma Hotel" )

      #   # Asign Stay and Room number
      #   1.times do

      #     # STAY FIELDS (INCLUIDING STAYS ALREADY FINISHED AND OPEN ONES)
      #     start_booking_date = Date.today + (rand(1..9) < 5 ? +1 : -1) * rand(2..30)
      #     end_booking_date = start_booking_date + rand(1..15)
      #     checked_in = start_booking_date <= Date.today ? (start_booking_date - rand(0..3)) : nil
      #     checked_out = end_booking_date if end_booking_date < Date.today

      #     # CREATE STAY INSTANCE
      #     stay = Stay.new(start_booking_date: start_booking_date, end_booking_date: end_booking_date, checked_in: checked_in, checked_out: checked_out)
      #     # ASIGN STAY INSTANCE TO USER
      #     stay.user = user

      #     # ASIGN STAY INSTANCE TO HOTEL
      #     stay.hotel = hotel


      #     # CREATE AND ASIGN ROOM
      #     room = Room.new(number: rand(100..500), room_type: ROOM_TYPE_LIST.sample)
      #     room.hotel = hotel
      #     room.save

      #     # ASIGN ROOM TO STAY
      #     stay.room = room

      #     # SAVE STAY's CHANGES
      #     stay.save

      #     # SAVE USER's CHANGES

# #################################################################################
# ##########                             END                            ###########
# #################################################################################

stay = user.stays.first

action = message_or_postback.respond_to?(:quick_reply) ? message_or_postback.quick_reply : message_or_postback.payload

action = message_or_postback.text if not action.present?

Rails.logger.debug("=== action")
Rails.logger.debug(action)
Rails.logger.debug("=== / action")

      # Message.back_to_app(stay, message_or_postback) if action == 'BACK_TO_APP_PAYLOAD' || action.downcase.strip.include?("app")
      Message.welcome(stay, message_or_postback) if action == 'GET_STARTED_PAYLOAD' || action.downcase.strip.include?("restart")
      Message.single_answer_slider(stay, message_or_postback, :service) if action == 'SERVICE_PAYLOAD' || action.downcase.strip.include?("service")
      Message.single_answer(stay, message_or_postback, :wifi) if action == 'WIFI_PAYLOAD' || action.downcase.strip.include?("wifi")
      Message.tree_answer(stay, message_or_postback) if action == 'LOCATION_PAYLOAD' || action.downcase.strip.include?("location")
      Message.display_selection(stay, message_or_postback, "Restaurants") if action == 'RESTAURANT_PAYLOAD' || action.downcase.strip.include?("restaurant")
      Message.display_selection(stay, message_or_postback, "Sights") if action == 'SIGHTS_PAYLOAD' || action.downcase.strip.include?("sight")
      Message.display_selection(stay, message_or_postback, "Rentals") if action == 'RENT_PAYLOAD' || action.downcase.strip.include?("rent")


    end

    # Back to app

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

      hotel = stay.hotel
      services = hotel.services.limit(3)

      url_base = "https://bellboy.fwd.wf"
      url_services = ["http://villadenaval.com/wp-content/uploads/2017/01/programas-restaurantes.jpg", "http://balancecolumbus.com/wp-content/uploads/2015/09/banner-hot-stone.jpg", "http://bruceworks.com.au/wp-content/uploads/2016/04/swimming-pool.jpg"]

      elements = []

      elements << {
        "title": "HOTEL SERVICES",
        "image_url": "http://www.notodohoteles.com/EPORTAL_IMGS/GENERAL/NOTODOHOTELES/IMG2-imgcw549a7e8073147/minigaleria-788-26RoomMateOscar_terraza.jpg",
        "subtitle": "Room Mate has amazing services, choose between them.",
        "default_action": {
          "type": "web_url",
          "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services",
          "messenger_extensions": true,
          "webview_height_ratio": "tall",
          "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services"
          },
          "buttons": [
            {
              "title": "View all",
              "type": "web_url",
              "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services",
              "messenger_extensions": true,
              "webview_height_ratio": "tall",
              "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services"
            }
          ]
        }

        services.each_with_index do |service, index|
          elements << {
            "title": "#{service.title}",
            "image_url": url_services[index],
            "subtitle": "#{service.description.truncate(22, separator: /\s/)}",
            "default_action": {
              "type": "web_url",
              "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}",
              "messenger_extensions": true,
              "webview_height_ratio": "tall",
              "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}"
              },
              "buttons": [
                {
                  "title": "Select",
                  "type": "web_url",
                  "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}",
                  "messenger_extensions": true,
                  "webview_height_ratio": "tall",
                  "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}"
                }
              ]
            }
          end

          data = {"attachment": {
            "type": "template",
            "payload": {
              "template_type": "list",
              "elements": elements
            }
          }
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


      # Prepare data and photos
      element = []
      url_base = "https://bellboy.fwd.wf"
      url_locations = ["http://panoramaitctravel.com/shop/wp-content/uploads/2017/02/acceso-rapido-sagrada-familia.jpg", "https://www.stemaki.com/wp-content/uploads/2015/11/paqrue-guell.jpg", "http://4.bp.blogspot.com/-_QN4wdXbLXg/VY7GjOKjOiI/AAAAAAAABa4/SKM6aDfsvI0/s1600/A-walk-down-La-Rambla.-Barcelona-10.jpg",
                       "https://2.bp.blogspot.com/-ztWvfdAsCjs/VcBTfy0OwNI/AAAAAAABfqM/UR4Kft16SRY/s1600/P1010489.JPG","https://spotcase.co/spot_images/20150717/18/243f76733381572a2d9a4bee5b8a83b4/243f76733381572a2d9a4bee5b8a83b4.jpg","http://www.bcnrestaurantes.com/img-trans/productos/22745/fotos/575-58774cf537719-%20.jpeg",
                       "https://www.aireuropa.com/airstatic/contents/63d65d3a-73e4-4f03-ba08-a73ec5b1b6e4.png","https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Hertz_Logo.svg/1200px-Hertz_Logo.svg.png","https://reskytnew.s3.amazonaws.com/857/plato-visitasandorra-visitas-andorra-12877_ppc.jpg"]

      # Select locations by category
      locations = stay.hotel.locations.where(category: category)

      counter = 0 if category == "Sights"
      counter = 3 if category == "Restaurants"
      counter = 5 if category == "Rentals"

      # Create array to display
      locations.each do |location|

        element << {
          "title": "#{location.name}",
          "image_url": url_locations[counter],
          "subtitle": "#{location.address}",
          "default_action": {
            "type": "web_url",
            "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/locations/#{location.id}",
            "messenger_extensions": true,
            "webview_height_ratio": "tall",
            "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/locations/#{location.id}"
            },
            "buttons":[
              {
                "type":"web_url",
                "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/locations/#{location.id}",
                "title": "Route me to #{location.name}"
                },{
                  "type":"postback",
                  "title":"Keep on Chatting",
                  "payload":"GET_STARTED_PAYLOAD"
                }
              ]
            }

            # Array counter
            counter += 1

          end

      # Create data to send (input: array of elements)
      data = {
        "attachment":{
          "type":"template",
          "payload":{
            "template_type":"generic",
            "elements": element
          }
        }
      }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end


  end
end


