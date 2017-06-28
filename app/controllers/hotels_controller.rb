class HotelsController < ApplicationController

  def show
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.first
  end

  def calendar_mobile
    calendar_info_generation
    @date_range = (@start_date..(@start_date + 2.days)).to_a
    user_data_generation
  end

  def calendar_month
    calendar_info_generation
    @date_range = (@start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week).to_a
    user_data_generation
  end

  def calendar_week
    calendar_info_generation
    #calculation for week calendar
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week).to_a
  end

  def user_data_generation
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @users = User.all
    @start_booking_dates = []
    @hotel.stays.each do |stay|
      @start_booking_dates << stay.start_booking_date.to_date
    end

    test1 = Stay.group_by_day(:start_booking_date).count
  end

  def charts

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

end
