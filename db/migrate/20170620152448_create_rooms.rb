class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.integer :number
      t.string :room_type
      t.references :hotel, foreign_key: true

      t.timestamps
    end
  end
end
