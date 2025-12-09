class AddTossPaymentsFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_id, :string
    add_reference :orders, :user, null: true, foreign_key: true
  end
end
