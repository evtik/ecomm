class CreateEcommOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_orders do |t|
      t.belongs_to :customer
      t.belongs_to :shipment
      t.belongs_to :coupon
      t.string :state
      t.monetize :subtotal

      t.timestamps
    end

    add_foreign_key :ecomm_orders, :ecomm_shipments, column: :shipment_id
    add_foreign_key :ecomm_orders, :ecomm_coupons, column: :coupon_id
  end
end
