class AddDeletedAtToHotels < ActiveRecord::Migration[5.0]
  def change
    add_column :hotels, :deleted_at, :datetime
    add_index :hotels, :deleted_at
  end
end
