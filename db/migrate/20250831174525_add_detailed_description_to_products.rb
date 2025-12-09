class AddDetailedDescriptionToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :detailed_description, :text
    add_column :products, :detail_image_urls, :text
  end
end
