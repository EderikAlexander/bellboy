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
  MESSAGE = {
    wifi_network: "Our WIFI network is: 'RMBARCELONA'",
    wifi_password: "And the password is: 'guests2017'",
    service: "Here there should be a list template.",
    locations: "Which option are you interested in?",
    breakfast: "Starts at 8:00 am and ends at 11:00 am",
    laundry: "Yes, do you want us to pick up your laundry?",
    room: "Your room number is ",
    events: "Yes we do in the third floor",
    swimming: "It opens at 1:00 pm and closes at 9:00 pm",
    attraction: "La sagrada familia! and Park Guell",
    custom_questions: "Here are some things you can ask me:
    - Who are you?
    - About our hotel services.
    - About our local tips.
    ",
    pick: "Or pick one of these options:",
    restart: "Here are some categories that may be helpful:",
    after_introduction: "What can I help you with?",
    after_question: "Is there anything else I can help you with?",
    who: "I\'m Andy, your best friend, personal concierge and the assistant that you deserve! =)",
    restaurants: "Check out our restaurants and bars:",
    massage: "Hard work pays off! You deserve a massage!",
    taxi: "Would you like us to order you a cab in front of the hotel or call one yourself?",
    taxi_ordered: "Alright, we booked a cab! It will arrive in 10 minutes in front of the hotel.",
  }

  # CHAT BOT METHODS
  class << self

    def process(message_or_postback)
      payload = message_or_postback

      # IS THE PAYLOAD A POSTBACK (CHECKING FOR THE REFERRAL)
      if payload.messaging['postback'].nil? || payload.messaging['postback']['referral'].nil?
        puts "it's already there"
      else
        referal_fb_id = payload.messaging['postback']['referral']['ref']
      end

      # SENDER ID
      messenger_id = payload.sender['id']

      # LINKING BETWEEN FACEBOOK UID AND MESSENGER ID
      if referal_fb_id.present?
        # SEARCH USER BY SENDER_ID BECAUSE IT ALREADY EXISTS (REFERAL IS NIL)
        user = User.all.where(uid: referal_fb_id).first
        # ASIGN THE MESSENGER ID TO THE USER
        user.sender_id = messenger_id
        user.save
      else
        # FIND THE USER USING THE REFERAL FB ID
        user = User.all.where(sender_id: messenger_id).first
      end

      # "..." when waiting for message
      begin
        payload.typing_on
      rescue Exception => e
        # Exception goes here
      end

      # #################################################################################
      # ##########.            THIS SHOULD BE MADE BY THE HOTEL               ###########
      # ##########       AUTOMATICALLY WHEN THE EMAIL SEND TO THE GUEST       ###########
      # #################################################################################

            # Create Hotel and Stays for the user (to be able to chat with the bot)
            hotel = Hotel.all.where( name: "Room Mate Carla Hotel" ).first
              # Asign Stay and Room number
                # STAY FIELDS (INCLUIDING STAYS ALREADY FINISHED AND OPEN ONES)
                start_booking_date = Date.today + (rand(1..9) < 5 ? +1 : -1) * rand(2..30)
                end_booking_date = start_booking_date + rand(1..15)
                checked_in = start_booking_date <= Date.today ? (start_booking_date - rand(0..3)) : nil
                checked_out = end_booking_date if end_booking_date < Date.today

                # CREATE STAY INSTANCE
                stay = Stay.new(start_booking_date: start_booking_date, end_booking_date: end_booking_date, checked_in: checked_in, checked_out: checked_out)
                # ASIGN STAY INSTANCE TO USER
                stay.user = user

                # ASIGN STAY INSTANCE TO HOTEL
                stay.hotel = hotel


                # CREATE AND ASIGN ROOM
                room = Room.new(number: rand(100..500), room_type: "Double")
                room.hotel = hotel
                room.save

                # ASIGN ROOM TO STAY
                stay.room = room

                # SAVE STAY's CHANGES
                stay.save

      # #################################################################################
      # ##########                             END                            ###########
      # #################################################################################

      action = message_or_postback.respond_to?(:quick_reply) ? message_or_postback.quick_reply : message_or_postback.payload

      action = message_or_postback.text if not action.present?

      Rails.logger.debug("=== action")
      Rails.logger.debug(action)
      Rails.logger.debug("=== / action")

    # SAVE MESSAGE FORM USER
    Message.create(content: payload, from: "user", stay_id: stay.id)


      # POSTBACKS
      if action == 'GET_STARTED_PAYLOAD' || action.downcase.strip.include?("restart")
        Message.welcome(stay, message_or_postback)
      elsif action == 'KEEP_CHATTING_PAYLOAD' || action.downcase.strip.match("help")
        Message.restart_after_introduction(stay, message_or_postback)
      elsif action == 'SERVICE_PAYLOAD' || action.downcase.strip.include?("service")
        Message.single_answer_slider(stay, message_or_postback, :service)
      elsif action == 'WIFI_PAYLOAD' || action.downcase.strip.include?("wifi")
        Message.single_answer(stay, message_or_postback, :wifi_network)
      elsif action == 'LOCATION_PAYLOAD' || action.downcase.strip.include?("tips")
        Message.tree_answer(stay, message_or_postback)
      elsif action == 'RESTAURANT_PAYLOAD' || action.downcase.strip.include?("restaurant")
        Message.display_selection(stay, message_or_postback, "Restaurants")
      elsif action == 'SIGHTS_PAYLOAD' || action.downcase.strip.include?("sight")
        Message.display_selection(stay, message_or_postback, "Sights")
      elsif action == 'RENT_PAYLOAD' || action.downcase.strip.include?("rent")
        Message.display_selection(stay, message_or_postback, "Rentals")
      elsif action == 'ORDER_CAB_PAYLOAD'
        Message.single_answer(stay, message_or_postback, :taxi_ordered)
      elsif action == 'TAXI_PAYLOAD' || action.downcase.strip.include?("taxi") || action.downcase.strip.include?("cab")
        Message.taxi(stay, message_or_postback, :taxi)
      elsif action == 'OPTIONS_PAYLOAD' || action.downcase.strip.include?("option")
        Message.options(stay, message_or_postback)
      elsif action == 'HOTEL_PAYLOAD' || action.downcase.strip.include?("call hotel") || action.downcase.strip.include?("phone")
        Message.call_hotel(stay, message_or_postback)
      elsif action == 'ROUTE_HOTEL_PAYLOAD' || action.downcase.strip.include?("call hotel") || action.downcase.strip.include?("phone")
        Message.call_hotel(stay, message_or_postback)


      # TYPED MESSAGES (HUMANIZER)
    elsif action.downcase.strip.include?("tired") || action.downcase.strip.include?("massage") || action.downcase.strip.include?("relax")
      Message.single_answer(stay, message_or_postback, :massage)
    elsif action.downcase.strip.include?("hungry") || action.downcase.strip.include?("bar") || action.downcase.strip.include?("eat") || action.downcase.strip.include?("restaurant")
      Message.single_answer(stay, message_or_postback, :restaurants)
    elsif action.downcase.strip.include?("who are you") || action.downcase.strip.include?("who is this")
      Message.single_answer(stay, message_or_postback, :who)
    elsif action.downcase.strip.include?("thanks")
      Message.thanks(stay, message_or_postback)
    elsif action.downcase.strip.include?("something to say")
      Message.special_thanking(stay, message_or_postback)
    # elsif (action.downcase.strip.include?("hi") || action.downcase.strip.include?("hello") || action.downcase.strip.include?("hey") || action.downcase.strip.include?("yo") || action.downcase.strip.include?("ciao") || action.downcase.strip.include?("bon dia"))
    #   Message.hello(stay, message_or_postback, action)
  else
    Message.default_answer(stay, message_or_postback)
  end
end

def default_answer(stay, message_or_postback)

  data = {
    text: "Sorry #{stay.user.first_name}, I didn't get that one!",
  }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    def thanks(stay, message_or_postback)

      data = {
        text: "You're welcome! I'm here to help you anytime...",
      }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    def special_thanking(stay, message_or_postback)

      data = {
        text: "Without Le Wagon I wouldn't be here! I would like to thank Gus, teachers and TAs! 🙌👍",
      }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

      # Thanking image
      data = {
        "attachment":{
          "type": "image",
          "payload":{
            "url": "http://res.cloudinary.com/montolio/image/upload/v1498747237/special_thanking_ughcph.jpg"
          }
        }
      }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

    end

    def call_hotel(stay, message_or_postback)
      data = {
        "attachment":
        {
          "type":"template",
          "payload":
          {
            "template_type":"button",
            "text":"Hi, just push the button and you will call your hotel.",
            "buttons":[
             {
              "type":"phone_number",
              "title":"Call my Hotel",
              "payload":"+31619663369"
            }
          ]
        }
      }
    }
    message_or_postback.reply(data)
    Message.create(content: data, from: "bot", stay: stay)

    Message.restart_after_question(stay, message_or_postback)


  end

    # Restart method
    def restart_after_introduction(stay, message_or_postback)

      data = {
        text: MESSAGE[:after_introduction],
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
                title: "LOCAL TIPS",
                payload: "LOCATION_PAYLOAD",
                },
                {
                  content_type:"text",
                  title: "MORE OPTIONS",
                  payload: "OPTIONS_PAYLOAD",
                  },
                  {
                    content_type: "text",
                    title: "THANKS ANDY",
                    payload:"THANKS_PAYLOAD",
                  }
                ]
              }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    def restart_after_question(stay, message_or_postback)

      data = {
        text: MESSAGE[:after_question],
        quick_replies:[
          {
            content_type:"text",
            title: "SERVICE",
            payload: "SERVICE_PAYLOAD",
            },
            {
              content_type:"text",
              title: "LOCAL TIPS",
              payload: "LOCATION_PAYLOAD",
              },
              {
                content_type:"text",
                title: "MORE OPTIONS",
                payload: "OPTIONS_PAYLOAD",
                },
                {
                  content_type: "text",
                  title: "THANKS ANDY",
                  payload:"THANKS_PAYLOAD",
                }
              ]
            }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    # Pick
    def pick(stay, message_or_postback)

      data = {
        text: MESSAGE[:pick],
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
                title: "LOCAL TIPS",
                payload: "LOCATION_PAYLOAD",
                },
                {
                  content_type:"text",
                  title: "MORE OPTIONS",
                  payload: "OPTIONS_PAYLOAD",
                }
              ]
            }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    # Restart method
    def restart(stay, message_or_postback)

      data = {
        text: MESSAGE[:after_question],
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
                title: "LOCAL TIPS",
                payload: "LOCATION_PAYLOAD",
                },
                {
                  content_type:"text",
                  title: "MORE OPTIONS",
                  payload: "OPTIONS_PAYLOAD",
                }
              ]
            }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
    end

    def options(stay, message_or_postback)

      data = {
        text: MESSAGE[:restart],
        quick_replies:[
          {
            content_type:"text",
            title: "TAXI",
            payload: "TAXI_PAYLOAD",
            },
            {
              content_type: "text",
              title: "CALL HOTEL",
              payload:"HOTEL_PAYLOAD",
              },
              {
                content_type:"text",
                title: "ROUTE ME TO HOTEL",
                payload: "ROUTE_HOTEL_PAYLOAD",
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
        text: "Hi #{stay.user.first_name}! Welcome to the Room Mate Carla Hotel.",
      }

      # Trigger Welcome message
      message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)

      # Restart method
      Message.single_answer(stay, message_or_postback, :custom_questions)
    end

    # Hello message
    # def hello(stay, message_or_postback, input)

      # if input.include?("hi")
      #   data = {
      #     text: "Hi #{stay.user.first_name}!"
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # elsif input.include?("bon dia")
      #   data = {
      #     text: "Bon dia #{stay.user.first_name}! Ruben, is today a great day??? "
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # elsif input.include?("hello")
      #   data = {
      #     text: "Hello #{stay.user.first_name}!"
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # elsif input.include?("ciao")
      #   data = {
      #     text: "Ciao Are you a friend of Francesco? Be careful with your answer, I might not speak with you otherwise..."
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # elsif input.include?("hola")
      #   data = {
      #     text: "Hola #{stay.user.first_name}!"
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # elsif input.include?("yo")
      #   data = {
      #     text: "Yo #{stay.user.first_name}!"
      #   }
      #   message_or_postback.reply(data)
      #   Message.restart(stay, message_or_postback)
      # end
    # end

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
      if input == :restaurants
        display_selection(stay, message_or_postback, "Restaurants")
      elsif input == :massage

      # Prepare data and photos
      element = []
      url_base = "https://bellboy-app.herokuapp.com" # "https://bellboy3.fwd.wf"

      # Select locations by category
      service = stay.hotel.services.where(title: "Massage").first

      # Create array to display
      element << {
        "title": "#{service.title}",
        "image_url": "https://res.cloudinary.com/montolio/image/upload/v" + service.photo.version + "/" + service.photo.public_id + "." + service.photo.format,
        "subtitle": "#{service.description.truncate(40, separator: /\s/)}",
        "default_action": {
          "type": "web_url",
          "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}",
          "messenger_extensions": true,
          "webview_height_ratio": "tall",
          "fallback_url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}"
          },
          "buttons":[
            {
              "type":"web_url",
              "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/services/#{service.id}",
              "title": "Book a massage"
              },{
                "type":"postback",
                "title":"Keep on Chatting",
                "payload":"GET_STARTED_PAYLOAD"
              }
            ]
          }

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

    elsif input == :who
      Message.restart_after_introduction(stay, message_or_postback)
    elsif input == :custom_questions
      Message.pick(stay, message_or_postback)
    elsif input == :wifi_network
      Message.single_answer(stay, message_or_postback, :wifi_password)
    elsif input == :wifi_password
      Message.restart_after_question(stay, message_or_postback)
    elsif input == :pick
      Message.restart(stay, message_or_postback)
    else
      Message.restart_after_question(stay, message_or_postback)
    end
  end

  def taxi (stay, message_or_postback, input)
    data = {
      text: MESSAGE[input]
    }

       # Trigger Welcome message
       message_or_postback.reply(data)

      # Save Message
      Message.create(content: data, from: "bot", stay: stay)
      if input == :taxi

        element = []
      url_base = "https://bellboy-app.herokuapp.com" # "https://bellboy3.fwd.wf"

      # Select locations by category
      service = stay.hotel.services.where(title: "Transportation").first

      # Create array to display
      element << {
        "title": "#{service.title}",
        "image_url": "https://res.cloudinary.com/montolio/image/upload/v" + service.photo.version + "/" + service.photo.public_id + "." + service.photo.format,
        "subtitle": "#{service.description.truncate(80, separator: /\s/)}",

        "buttons":[
          {
            "type": "postback",
            "title": "Book a cab",
            "payload": "ORDER_CAB_PAYLOAD"
            },{
              "type": "phone_number",
              "title": "Call a cab",
              "payload": "+31619663369"
            }
          ]
        }

      # Create data to send (input: array of elements)
      data = {
        "attachment":{
          "type": "template",
          "payload":{
            "template_type": "generic",
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


    # Single message answer
    def single_answer_slider(stay, message_or_postback, input)

      hotel = stay.hotel
      services = hotel.services.limit(3)

      url_base = "https://bellboy-app.herokuapp.com" # "https://bellboy3.fwd.wf"

      elements = []

      elements << {
        "title": "HOTEL SERVICES",
        "image_url": "http://www.notodohoteles.com/EPORTAL_IMGS/GENERAL/NOTODOHOTELES/IMG2-imgcw549a7e8073147/minigaleria-788-26RoomMateOscar_terraza.jpg",
        "subtitle": "Always feel at home at the Room Mate Gerard Hotel with our unique services.",
        "buttons": [
          {
            "title": "View all",
            "type": "web_url",
            "url": "#{url_base}/stays/#{stay.id}/hotels/#{stay.hotel.id}/services",
            "messenger_extensions": true,
            "webview_height_ratio": "tall",
            "fallback_url": "#{url_base}/stays/#{stay.id}/hotels/#{stay.hotel.id}/services"
          }
        ]
      }

      services.each_with_index do |service, index|
        elements << {
          "title": "#{service.title}",
          "image_url": "https://res.cloudinary.com/montolio/image/upload/v" + service.photo.version + "/" + service.photo.public_id + "." + service.photo.format,
          "subtitle": "#{service.description.truncate(60, separator: /\s/)}",
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

      # Is there anything else...? Question display
      Message.restart_after_question(stay, message_or_postback)

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
                },
                {
                  content_type:"text",
                  title: "SEE ALL",
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
      url_base = "https://bellboy-app.herokuapp.com" # "https://bellboy3.fwd.wf"

      url_locations = ["http://panoramaitctravel.com/shop/wp-content/uploads/2017/02/acceso-rapido-sagrada-familia.jpg", "https://www.stemaki.com/wp-content/uploads/2015/11/paqrue-guell.jpg", "http://4.bp.blogspot.com/-_QN4wdXbLXg/VY7GjOKjOiI/AAAAAAAABa4/SKM6aDfsvI0/s1600/A-walk-down-La-Rambla.-Barcelona-10.jpg",
       "https://2.bp.blogspot.com/-ztWvfdAsCjs/VcBTfy0OwNI/AAAAAAABfqM/UR4Kft16SRY/s1600/P1010489.JPG","https://spotcase.co/spot_images/20150717/18/243f76733381572a2d9a4bee5b8a83b4/243f76733381572a2d9a4bee5b8a83b4.jpg","http://www.bcnrestaurantes.com/img-trans/productos/22745/fotos/575-58774cf537719-%20.jpeg",
       "https://www.aireuropa.com/airstatic/contents/63d65d3a-73e4-4f03-ba08-a73ec5b1b6e4.png","https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Hertz_Logo.svg/1200px-Hertz_Logo.svg.png","https://reskytnew.s3.amazonaws.com/857/plato-visitasandorra-visitas-andorra-12877_ppc.jpg"]

      # Select locations by category
      locations = stay.hotel.locations.where(category: category)

      # Create array to display
      locations.each do |location|

        element << {
          "title": "#{location.name}",
          "image_url": "https://res.cloudinary.com/montolio/image/upload/v" + location.photo.version + "/" + location.photo.public_id + "." + location.photo.format,
          "subtitle": "#{location.address}",
          "buttons":[
            {
              "type": "web_url",
              "url": url_base + "/stays/#{stay.id}/hotels/#{stay.hotel.id}/locations/#{location.id}",
              "title": "Take me there"
              },
              {
                "type": "phone_number",
                "title": "Call #{location.name}",
                "payload": "+31619663369"
                },
                {
                  "type": "postback",
                  "title": "Keep on Chatting",
                  "payload": "KEEP_CHATTING_PAYLOAD"
                }
              ]
            }

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
