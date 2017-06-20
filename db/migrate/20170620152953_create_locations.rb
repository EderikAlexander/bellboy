class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :category
      t.references :hotel, foreign_key: true

      t.timestamps
    end
  end
end
