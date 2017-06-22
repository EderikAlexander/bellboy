class AddUserIdToHotels < ActiveRecord::Migration[5.0]
  def change
    add_reference :hotels, :user, foreign_key: true
  end
end
