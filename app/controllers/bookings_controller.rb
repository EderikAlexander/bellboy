class BookingsController < ApplicationController

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @service = Service.find(params[:service_id])
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @service = Service.find(params[:service_id])
    @bookings = Booking.all
    @booking = Booking.new
  end

  def create
    ### WORK on the logic
    # start_datetime_string = booking_params["start_datetime"]
    # start_datetime_tobook = DateTime.strptime(start_datetime_string, "%m/%d/%Y %H:%M %P")

    # end_datetime_string = booking_params["end_datetime"]
    # end_datetime_tobook = DateTime.strptime(end_datetime_string, "%m/%d/%Y %H:%M %P")

    start_date_hour_string = booking_params["day_selection"]
    # start_date_hour_string = params["time_booking"]["day_selection"]
    #=> "2017-06-15|11"
    start_date_string = start_date_hour_string.split("|")[0]
    #=> "2017-06-15"
    hour = start_date_hour_string.split("|")[1].to_i
    #=> "11"
    start_date_time = start_date_string.to_date
    #=> Thu, 08 Jun 2017
    year = start_date_time.year
    month = start_date_time.month
    day = start_date_time.day

    start_datetime_tobook = DateTime.new(year, month, day, hour, 0, 0, '+0')
    # start_datetime_tobook = DateTime.new(year, month, day, hour, 0, 0, '+2')

    end_datetime_tobook = DateTime.new(year, month, day, hour, 59, 0, '+0')
    # end_datetime_tobook = DateTime.new(year, month, day, hour, 59, 0, '+2')

    @booking = Booking.new()
    @booking.start_datetime = start_datetime_tobook
    @booking.end_datetime = end_datetime_tobook


    @booking.user = current_user

    @service = Service.find(params[:service_id])
    @booking.service = @service

    #
    booked = isTableBooked(@service, start_datetime_tobook, end_datetime_tobook)
    # used for the path method
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    if booked
      # you pass a message only once
      flash[:notice] = "book"
      # render 'services/show'
      redirect_to stay_hotel_service_path(@stay, @hotel, @service)
    else
      @booking.save
      redirect_to stay_hotel_service_booking_path(@stay, @hotel, @service, @booking)
      # /stays/:stay_id/hotels/:hotel_id/services/:service_id/bookings/:id(.:format)
      #redirect_to stay_hotel_service_bookings_path(@stay, @hotel, @service)
    end
  end

  def isTableBooked(service, start_datetime_tobook, end_datetime_tobook)
    booked = false

    service.bookings.each do |booking|
      if (start_datetime_tobook..end_datetime_tobook).overlaps?(booking.start_datetime..booking.end_datetime)
        booked = true
      end
    end
    return booked
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @service = Service.find(params[:service_id])
    redirect_to stay_hotel_service_path(@stay, @hotel, @service)
  end

  private
  def booking_params
    params.require(:time_booking).permit(:day_selection)
    # params.require(:booking).permit(:start_datetime, :end_datetime)
  end

end
