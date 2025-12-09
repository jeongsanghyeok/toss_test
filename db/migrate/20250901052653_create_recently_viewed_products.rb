class CreateRecentlyViewedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :recently_viewed_products do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
