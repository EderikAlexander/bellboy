# HOTEL CONSTANTS
HOTEL_LIST = [ { name: "Room Mate Emma Hotel", address: "Carrer del Rosselló, 205, 08008 Barcelona", city: "Barcelona" },
 { name: "Room Mate Pau", address: "Carrer de Fontanella, 7, 08010 Barcelona", city: "Barcelona" },
 { name: "Room Mate Carla Hotel", address: "Carrer de Mallorca, 288, 08037 Barcelona", city: "Barcelona" },
 { name: "Room Mate Anna Hotel", address: "Carrer d'Aragó, 271, 08007 Barcelona", city: "Barcelona" },
 { name: "Room Mate Gerard", address: "Carrer d'Ausiàs Marc, 34, 08010 Barcelona", city: "Barcelona" } ]

LOCATION_LIST = [ { name: "Sagrada Familia", address: "Carrer de la Marina, 253 08013 Barcelona", category: "Sight seeing" },
 { name: "Park Güell", address: "Carrer d'Olot, 7 08024 Barcelona", category: "Sight seeing" },
 { name: "La Rambla", address: "Rambla dels Caputxins, 1807 08002 Barcelona", category: "Sight seeing" },
 { name: "Tickets", address: "Av. del Paraŀlel, 164, 08015 Barcelona", category: "Restaurants" },
 { name: "Tapas 24", address: "Carrer de la Diputació, 269, 08007 Barcelona", category: "Restaurants" },
 { name: "El atril", address: "Carrer dels Carders, 23, 08003 Barcelona", category: "Restaurants" },
 { name: "EuropeCar", address: "Gran Via de les Corts Catalanes, 680, 08010 Barcelona", category: "Rentals" },
 { name: "Hertz", address: "Avinguda Diagonal, 622, 08023 Barcelona", category: "Rentals" },
 { name: "Moto Rent", address: "Carrer de Roger de Llúria, 31, 08009 Barcelona", category: "Rentals" }
]
# CREATE LOCATIONS

# CREATE SERVICES
# MISSING

# MESSAGE LIST
MESSAGE_LIST =[ { welcome: { "text": "Welcome to the our hotel" } },
                { question: { "text": "what is the wifi password?" } , answer: { "text": "The wifi password is: RoomMate2017" } },
                { question: { "text": "when is the breakfast" } , answer: { "text": "Starts at 8:00 am and ends at 11:00 am" } },
                { question: { "text": "what services do you offer" } , answer: { "text": "Cleaning, massage, transportation"  } },
                { question: { "text": "what´s my room number" } , answer: { "text": "Your room number is 216" } },
                { question: { "text": "do you have a room for events" } , answer: { "text": "Yes we do" } },
                { question: { "text": "what time does the pool open" } , answer: { "text": "It opens at 1:00 pm and closes at 9:00 pm" } },
                { question: { "text": "are there any interesting places to visit nearby" } , answer: { "text": "La sagrada familia! and Park Guell" } }
              ]

# ROOM TYPES
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

# SEEDING PROCESS #

# CREATE AND SAVE HOTEL
hotel = Hotel.new(HOTEL_LIST[rand(0..4)])
hotel.save

  3.times do

  # CREATE USER
  user = User.new(email: Faker::Internet.free_email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, passport: Faker::Number.number(8), password: "1234567890") # facebook_id: Faker::Number.number(15)
  user.save

  # ASIGN STAY TO USER
  rand(1..3).times do

    # STAY FIELDS (INCLUIDING STAYS ALREADY FINISHED AND OPEN ONES)
    start_booking_date = Date.today + (rand(1..9) < 5 ? +1 : -1) * rand(2..30)
    end_booking_date = start_booking_date + rand(1..15)
    checked_in = start_booking_date - rand(0..5) if start_booking_date < Date.today || rand(0..9) < 5
    checked_out = end_booking_date if end_booking_date < Date.today

    # CREATE STAY INSTANCE
    stay = Stay.new(start_booking_date: start_booking_date, end_booking_date: end_booking_date, checked_in: checked_in, checked_out: checked_out)

    # ASIGN STAY INSTANCE TO USER
    stay.user = user

    # ASIGN STAY INSTANCE TO HOTEL
    stay.hotel = hotel

    # CREATE MESSAGES IF THE DATE OF BOOKING IS PASSED
    if checked_in < Date.Today
      # WELCOME MESSAGE
        message_welcome = Message.new(stay_id: stay.id, from: "bot", content: MESSAGE_LIST[0][:welcome]) # NEED TO PASS A JSON AS CONTENT:
        message_welcome.save
        stay.message = message_welcome

      # RANDOM MESSAGES
      rand(1..10).times do
        random = rand(1..12)
        message_user = Message.new(stay_id: stay.id, from: "user", content: MESSAGE_LIST[random][:question]) # NEED TO PASS A JSON AS CONTENT:
        message_user.save
        message_bot = Message.new(stay_id: stay.id, from: "bot", content: MESSAGE_LIST[random][:answer]) # NEED TO PASS A JSON AS CONTENT:
        message_bot.save
        stay.message = message_user
        stay.message = message_bot
      end
    end

    # CREATE AND ASIGN ROOM
    room = Room.new(number: rand(100..500), room_type: ROOM_TYPE_LIST.sample)
    room.hotel = hotel
    room.save

    # ASIGN ROOM TO STAY
     stay.room = room

    # SAVE STAY
    stay.save
    end

  end

puts "Finished seeding process..."
