class CreateBookingSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :booking_settings do |t|
      t.integer :slot_interval_minutes, null: false, default: 30
      t.integer :min_notice_hours, null: false, default: 24
      t.integer :max_advance_days, null: false, default: 60
      t.integer :buffer_minutes, null: false, default: 0
      t.string  :time_zone, null: false, default: "Europe/Paris"

      t.timestamps
    end
  end
end
