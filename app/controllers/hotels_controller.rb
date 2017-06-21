class HotelsController < ApplicationController

  def show
    @hotel = Hotel.first
  end


end
