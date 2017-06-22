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
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)

    @booking.user = current_user

    @service = Service.find(params[:service_id])
    @booking.service = @service

    start_datetime_tobook = Time.new(booking_params["start_datetime(1i)"], booking_params["start_datetime(2i)"], booking_params["start_datetime(3i)"], booking_params["start_datetime(4i)"], booking_params["start_datetime(5i)"])
    end_datetime_tobook = Time.new(booking_params["end_datetime(1i)"], booking_params["end_datetime(2i)"], booking_params["end_datetime(3i)"], booking_params["end_datetime(4i)"], booking_params["end_datetime(5i)"])

    booked = isTableBooked(@service, start_datetime_tobook, end_datetime_tobook)

    # used for the _path method
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    if booked
      render 'new'
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
    redirect_to stay_hotel_service_bookings_path(@stay, @hotel, @service)
  end

  private
  def booking_params
    params.require(:booking).permit(:start_datetime, :end_datetime)
  end

end
