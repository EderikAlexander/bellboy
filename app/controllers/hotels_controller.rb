class HotelsController < ApplicationController

  def show
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.first
  end

  def calendar_month
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])

    @hotel_bookings = []
    @hotel.services.each do |service|
      service.bookings.each do |booking|
        @hotel_bookings << booking
      end
    end

    @start_date = params.fetch(:start_date, Date.today).to_date
    @date_range = (@start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week).to_a
  end

  def calendar_week
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])

    # bookings for all the services of an hotel
    @hotel_bookings = []
    @hotel.services.each do |service|
      service.bookings.each do |booking|
        @hotel_bookings << booking
      end
    end

    @start_date = params.fetch(:start_date, Date.today).to_date
    #calculation for week calendar
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week).to_a
  end

end
