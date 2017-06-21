class AddRoomAgainToStays < ActiveRecord::Migration[5.0]
  def change
    add_column :stays, :room_id, :integer
  end
end
