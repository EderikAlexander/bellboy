class StaysController < ApplicationController

  def index
    # STAY OF THE CURRENT USER
    # @stays = Stay.where(current_user)
    @stays = Stay.all
  end

  def show
     @stay = Stay.find(params[:id])

  end
end
