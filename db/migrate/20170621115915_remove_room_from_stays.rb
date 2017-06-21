class RemoveRoomFromStays < ActiveRecord::Migration[5.0]
  def change
    remove_column :stays,:room_id
  end
end
