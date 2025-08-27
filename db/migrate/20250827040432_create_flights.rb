class CreateFlights < ActiveRecord::Migration[7.2]
  def change
    create_table :flights do |t|
      t.string :origin, null: false
      t.string :destination, null: false
      t.date :departure_date, null: false
      t.date :return_date
      t.integer :adults, default: 1
      t.string :currency, default: 'USD'
      t.timestamps
    end
  end
end
