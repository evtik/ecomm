class CreateEcommAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_addresses do |t|
      t.belongs_to :customer
      t.belongs_to :order
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :city
      t.string :zip
      t.string :country
      t.string :phone
      t.string :address_type
    end

    add_foreign_key :ecomm_addresses, :ecomm_orders, column: :order_id
  end
end
