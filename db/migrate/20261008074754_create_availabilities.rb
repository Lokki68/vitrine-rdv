class CreateAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :availabilities do |t|
      t.integer :weekday, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :availabilities, :weekday
  end
end
