class ServicesController < ApplicationController

  def new
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @service = Service.new
  end

  def create
    @stay = Stay.find(params[:stay_id])
    @service = Service.new(service_params)
    @hotel = Hotel.find(params[:hotel_id])
    @service.hotel = @hotel
    if @service.save
      redirect_to stay_hotel_service_path(@stay, @hotel, @service)
    else
      render 'new'
    end
  end

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @services = Service.all
    # raise
  end

  def show
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @service = Service.find(params[:id])
    @bookings = @service.bookings
    @disabled_hours = []
    @bookings.each do |booking|
      @disabled_hours << booking.start_datetime.hour.to_s
    end

    @booking = Booking.new
    calendar_month

    # @bookable_hours = ["9:00", "10:00", "11:00", "12:00", "13:00",  "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    @service_hours = ["9", "10", "11", "12", "13",  "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]

    @bookable_hours = [[], []]
    found = false

    @service_hours.each do |service_hour|
      @disabled_hours.each do |disabled_hour|
        if disabled_hour == service_hour
          @bookable_hours[0] << service_hour
          @bookable_hours[1] << 1
          found = true
        end
      end
      if found == true
        # nothing, you already wrote it
      else
        @bookable_hours[0] << service_hour
        @bookable_hours[1] << 0
      end
      found = false
    end

    @bookable_hours

  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    redirect_to stay_hotel_services_path(@stay, @hotel)
  end

  def search
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    if params[:title].empty?
      redirect_to stay_hotel_services_path(params[:stay_id],params[:hotel_id])
    else
      #find all the searches that include a substring
      # @flats_by_name = Flat.where('lower(name) LIKE ?', '%' + params[:name].downcase + '%')
      # @flats_by_dest = Flat.near(params[:destination], 50)
      @services = Service.where('lower(title) LIKE ?', '%' + params[:title].downcase + '%')

      #find all the searches with what ever case
      # @flats = Flat.where('lower(name) = ?', params[:name].downcase)
      # Flat.find_by(name: params[:name]) << @flats
    end
  end

  def calendar_month
    calendar_info_generation
    @date_range = (@start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week).to_a
    # user_data_generation
  end

  def calendar_week
    calendar_info_generation
    #calculation for week calendar
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week).to_a
  end

  def calendar_info_generation
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])

    @hotel_bookings = []

    @hotel.services.each do |service|
      service.bookings.each do |booking|
        @hotel_bookings << booking
      end
    end

    @restaurants_id = @hotel.services[0].id
    @massages_id = @hotel.services[1].id

    if params[:filter] == "restaurants"
      @hotel_bookings = @hotel_bookings.select { |hotel_booking| hotel_booking.service_id == @restaurants_id }
    end

    if params[:filter] == "massages"
      @hotel_bookings = @hotel_bookings.select { |hotel_booking| hotel_booking.service_id == @massages_id }
    end

    @start_date = params.fetch(:start_date, Date.today).to_date
  end

  private
  def service_params
    params.require(:service).permit(:title, :description, :start_time, :end_time, :price)
  end

end
