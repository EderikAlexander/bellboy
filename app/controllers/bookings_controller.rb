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
    raise
    start_datetime_string = booking_params["start_datetime"]
    start_datetime_tobook = DateTime.strptime(start_datetime_string, "%m/%d/%Y %H:%M %P")


    end_datetime_string = booking_params["end_datetime"]
    end_datetime_tobook = DateTime.strptime(end_datetime_string, "%m/%d/%Y %H:%M %P")

    @booking = Booking.new(booking_params)
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
      redirect_to stay_hotel_service_bookings_path(@stay, @hotel, @service)
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
    params.require(:booking).permit(:start_datetime, :end_datetime)
  end

end
