class ServicesController < ApplicationController

  def index
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.find(params[:hotel_id])
    @services = Service.all
    # raise
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


  def show
    @service = Service.find(params[:id])
  end

end
