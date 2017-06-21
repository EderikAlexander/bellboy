class AddRoomToStays < ActiveRecord::Migration[5.0]
  def change
    add_reference :stays, :room, foreign_key: true
  end
end
