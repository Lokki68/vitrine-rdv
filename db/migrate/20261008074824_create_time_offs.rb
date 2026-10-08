class CreateTimeOffs < ActiveRecord::Migration[8.1]
  def change
    create_table :time_offs do |t|
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.string :reason

      t.timestamps
    end
    add_index :time_offs, [ :starts_on, :ends_on ]
  end
end
