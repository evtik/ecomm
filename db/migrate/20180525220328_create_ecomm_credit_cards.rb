class CreateEcommCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_credit_cards do |t|
      t.belongs_to :order
      t.string :number
      t.string :cardholder
      t.string :month_year
      t.string :cvv
    end

    add_foreign_key :ecomm_credit_cards, :ecomm_orders, column: :order_id
  end
end
