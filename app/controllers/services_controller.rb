class ServicesController < ApplicationController

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
  end

end
