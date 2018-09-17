class CreateEcommShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_shipments do |t|
      t.string :shipping_method
      t.integer :days_min
      t.integer :days_max
      t.monetize :price
    end
  end
end
