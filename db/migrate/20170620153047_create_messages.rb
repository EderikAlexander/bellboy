class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :from
      t.json :content
      t.references :stay, foreign_key: true

      t.timestamps
    end
  end
end
