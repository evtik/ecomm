class CreateEcommLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_line_items do |t|
      t.belongs_to :product
      t.belongs_to :order
      t.integer :quantity

      t.timestamps
    end

    add_foreign_key :ecomm_line_items, :ecomm_orders, column: :order_id
  end
end
