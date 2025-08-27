class CreateCountries < ActiveRecord::Migration[7.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :countries, :code, unique: true
  end
end
