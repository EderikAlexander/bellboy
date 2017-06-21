class LocationsController < ApplicationController

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end
end
