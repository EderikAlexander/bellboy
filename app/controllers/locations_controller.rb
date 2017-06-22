class LocationsController < ApplicationController

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    # @locations = Location.all

    @locations = Location.all
    @locations = Location.where.not(latitude: nil, longitude: nil)

    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow render_to_string(partial: "/locations/mapbox", locals: { stay: @stay, hotel: @hotel, location: location })
    end


  end

  def show
    @location = Location.find(params[:id])
  end
end
