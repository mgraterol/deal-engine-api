class CreateAirports < ActiveRecord::Migration[7.2]
  def change
    create_table :airports do |t|
      t.string :name
      t.string :city
      t.string :code
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
    add_index :airports, :code, unique: true
  end
end
