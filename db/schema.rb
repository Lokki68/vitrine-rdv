# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_08_075559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "client_name", null: false
    t.string "client_email", null: false
    t.string "client_phone", null: false
    t.text "client_notes"
    t.timestamptz "starts_at", null: false
    t.timestamptz "ends_at", null: false
    t.string "status", default: "pending_payment", null: false
    t.timestamptz "expires_at"
    t.string "stripe_checkout_session_id"
    t.string "stripe_checkout_intent_id"
    t.string "google_event_id"
    t.string "cancellation_token", null: false
    t.timestamptz "paid_at"
    t.timestamptz "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cancellation_token"], name: "index_appointments_on_cancellation_token", unique: true
    t.index ["expires_at"], name: "index_appointments_on_expires_at"
    t.index ["service_id"], name: "index_appointments_on_service_id"
    t.index ["starts_at"], name: "index_appointments_on_starts_at"
    t.index ["status"], name: "index_appointments_on_status"
    t.index ["stripe_checkout_session_id"], name: "index_appointments_on_stripe_checkout_session_id", unique: true
    t.exclusion_constraint "tstzrange(starts_at, ends_at) WITH &&", where: "(status)::text = ANY ((ARRAY['pending_payment'::character varying, 'confirmed'::character varying])::text[])", using: :gist, name: "no_overlapping_active_appointments"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "weekday", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekday"], name: "index_availabilities_on_weekday"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.jsonb "content", default: "{}", null: false
    t.string "status", default: "draft", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published_at"], name: "index_blog_posts_on_published_at"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
    t.index ["status"], name: "index_blog_posts_on_status"
  end

  create_table "booking_settings", force: :cascade do |t|
    t.integer "slot_interval_minutes", default: 30, null: false
    t.integer "min_notice_hours", default: 24, null: false
    t.integer "max_advance_days", default: 60, null: false
    t.integer "buffer_minutes", default: 0, null: false
    t.string "time_zone", default: "Europe/Paris", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "duration_minutes", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "deposit_cents", default: 0, null: false
    t.string "currency", default: "eur", null: false
    t.boolean "active", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "position"], name: "index_services_on_active_and_position"
    t.index ["slug"], name: "index_services_on_slug", unique: true
  end

  create_table "time_offs", force: :cascade do |t|
    t.date "starts_on", null: false
    t.date "ends_on", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["starts_on", "ends_on"], name: "index_time_offs_on_starts_on_and_ends_on"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
