class CreateVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku
      t.decimal :price_override
      t.integer :stock
      t.string :size
      t.string :color
      t.boolean :is_active

      t.timestamps
    end
  end
end
