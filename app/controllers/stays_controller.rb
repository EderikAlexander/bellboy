class StaysController < ApplicationController

def index

  # STAY OF THE CURRENT USER

  @stays = Stay.where(current_user)
end

def show

end

end
