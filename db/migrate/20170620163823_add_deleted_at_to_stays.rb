class AddDeletedAtToStays < ActiveRecord::Migration[5.0]
  def change
    add_column :stays, :deleted_at, :datetime
    add_index :stays, :deleted_at
  end
end
