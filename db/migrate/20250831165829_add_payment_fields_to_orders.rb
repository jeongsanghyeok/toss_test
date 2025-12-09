class AddPaymentFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :payment_key, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :payment_status, :string
  end
end
