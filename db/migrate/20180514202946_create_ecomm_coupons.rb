class CreateEcommCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_coupons do |t|
      t.string :code
      t.datetime :expires
      t.integer :discount
    end
  end
end
