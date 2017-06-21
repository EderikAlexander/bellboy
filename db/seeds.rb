# CONSTANTS

HOTEL_LIST = [ { name: "Room Mate Emma Hotel", address: "Carrer del Rosselló, 205, 08008 Barcelona", city: "Barcelona" },
               { name: "Room Mate Pau", address: "Carrer de Fontanella, 7, 08010 Barcelona", city: "Barcelona" },
               { name: "Room Mate Carla Hotel", address: "Carrer de Mallorca, 288, 08037 Barcelona", city: "Barcelona" },
               { name: "Room Mate Anna Hotel", address: "Carrer d'Aragó, 271, 08007 Barcelona", city: "Barcelona" },
               { name: "Room Mate Gerard", address: "Carrer d'Ausiàs Marc, 34, 08010 Barcelona", city: "Barcelona" }
              ]

MESSAGE_LIST =[ { question: {} , answer: {} }
               ]

ROOM_TYPE_LIST = ["Single", "Double", "Triple", "Suite", "Studio"]



puts "Starting seeding proces..."

# DESTROY ALL (OVERIDING THE PARANOIA GEM)
Service.really_destroy!
Location.really_destroy!
Room.really_destroy!
Message.really_destroy!
Stay.really_destroy!
User.really_destroy!
Hotel.really_destroy!

# SEEDING PROCESS
hotel = Hotel.new(HOTEL_LIST[rand(0..4)])

# CREATE LOCATIONS


# CREATE SERVICES





# CREATE USERS

10.times do |_user|

  user = User.new(email: Faker::Internet.free_email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, passport: Faker::Number.number(8), password: 1234567890, facebook_id: Faker::Number.number(15))


  # ASIGN STAY TO USER
  rand(1..3).times do |_stay|

    # STAY FIELDS (INCLUIDING STAYS ALREADY FINISHED AND OPEN ONES)
    start_booking_date = Date.today + (rand(1..9) < 5 ? +1 : -1) * rand(2..30)
    end_booking_date = start_booking_date + rand(1..15)
    checked_in = start_booking_date - rand(0..5) if start_booking_date < Date.today || rand(0..9) < 5
    checked_out = end_booking_date if end_booking_date < Date.today

    # CREATE STAY INSTANCE
    stay = Stay.new(start_booking_date, end_booking_date, checked_in, checked_out)

      # ASIGN STAY INSTANCE TO USER
      user.stay = stay

      # ASIGN STAY INSTANCE TO HOTEL
      hotel.stay = stay

    # CREATE MESSAGES
      # WELCOME MESSAGE
        message_welcome = Message.new(stay_id: stay.id, from: "bot", content: MESSAGE[:question]) # NEED TO PASS A JSON AS CONTENT:
        user.message = message_welcome

      # RANDOM MESSAGES
      rand(1..10).times do |_message|
        random = rand(0..4)
        message_user = Message.new(stay_id: stay.id, from: "user", content: MESSAGE[:question]) # NEED TO PASS A JSON AS CONTENT:
        message_bot = Message.new(stay_id: stay.id, from: "bot", content: MESSAGE[:answer]) # NEED TO PASS A JSON AS CONTENT:
        user.message = message_user
        user.message = message_bot
      end

    # ASIGN ROOM TO USER (MISSING IN THE ASSOCIATIONS)
    room = Room.new(number: rand(100..2000), room_type: ROOM_TYPE_LIST[rand(0..4)])
    user.room = room

  end
end

puts "Finished seeding proces..."
