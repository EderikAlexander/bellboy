class CreateStays < ActiveRecord::Migration[5.0]
  def change
    create_table :stays do |t|
      t.string :start_booking_date
      t.string :end_booking_date
      t.string :checked_in
      t.string :checked_out
      t.references :user, foreign_key: true
      t.references :hotel, foreign_key: true

      t.timestamps
    end
  end
end
