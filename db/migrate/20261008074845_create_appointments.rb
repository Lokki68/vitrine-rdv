class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :service, null: false
      t.string :client_name, null: false
      t.string :client_email, null: false
      t.string :client_phone, null: false
      t.text :client_notes
      t.timestamptz :starts_at, null: false
      t.timestamptz :ends_at, null: false
      t.string :status, null: false, default: "pending_payment"
      t.timestamptz :expires_at
      t.string :stripe_checkout_session_id
      t.string :stripe_checkout_intent_id
      t.string :google_event_id
      t.string :cancellation_token, null: false
      t.timestamptz :paid_at
      t.timestamptz :cancelled_at

      t.timestamps
    end

    add_index :appointments, :status
    add_index :appointments, :starts_at
    add_index :appointments, :expires_at
    add_index :appointments, :cancellation_token, unique: true
    add_index :appointments, :stripe_checkout_session_id, unique: true

    execute <<~SQL
      ALTER TABLE appointments
        ADD CONSTRAINT no_overlapping_active_appointments
        EXCLUDE USING gist (tstzrange(starts_at, ends_at) WITH &&)
        WHERE (status IN ('pending_payment', 'confirmed'));
    SQL
  end

  def down
    execute "ALTER TABLE appointments DROP CONSTRAINT no_overlapping_active_appointments;"
    drop_table :appointments
  end
end
