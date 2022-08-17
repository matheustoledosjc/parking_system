class CreateParkings < ActiveRecord::Migration[7.0]
  def change
    create_table :parkings do |t|
      t.integer :status, null: false
      t.string :plate, null: false
      t.datetime :paid_at, null: true
      t.datetime :left_at, null: true

      t.timestamps
    end
  end
end
