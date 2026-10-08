class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :duration_minutes, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :deposit_cents, null: false, default: 0
      t.string :currency, null: false, default: 'eur'
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :services, :slug, unique: true
    add_index :services, [:active, :position]
  end
end
