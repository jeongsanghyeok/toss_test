class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :address
      t.decimal :total_price, precision: 10, scale: 2
      t.string :status
      t.string :session_id

      t.timestamps
    end
  end
end
