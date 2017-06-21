class HotelsController < ApplicationController

  def show
    @stay = Stay.find(params[:stay_id])
    @hotel = Hotel.first
  end


end
