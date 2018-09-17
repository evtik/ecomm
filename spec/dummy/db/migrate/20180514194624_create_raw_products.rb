class CreateRawProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :raw_products do |t|
      t.json :image
      t.string :name
      t.text :desc
      t.monetize :cost

      t.timestamps
    end
  end
end
