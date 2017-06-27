class LocationsController < ApplicationController

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    # @locations = Location.all

    @locations = Location.all
    @locations = Location.where.not(latitude: nil, longitude: nil)

    @locations = @locations.select { |l| l.category == "Restaurants"} if params[:filter] == 'restaurant'
    @locations = @locations.select { |l| l.category == "Rentals"} if params[:filter] == 'rentals'
    @locations = @locations.select { |l| l.category == "Sights"} if params[:filter] == 'Sights'

   @hash = convert_to_hash(@locations, @stay, @hotel)
  end

  def show
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @location = Location.find(params[:id])
  end


  private

  def convert_to_hash(locations, stay, hotel)
    Gmaps4rails.build_markers(locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow render_to_string(partial: "/locations/mapbox", locals: { stay: stay, hotel: hotel, location: location } )
    end
  end

end
