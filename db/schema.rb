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

ActiveRecord::Schema[8.0].define(version: 2026_05_19_030908) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "description"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.date "spent_at"
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "income_source_id"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["income_source_id"], name: "index_expenses_on_income_source_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "income_sources", force: :cascade do |t|
    t.string "name"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "payment_method"
    t.boolean "active"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.index ["user_id"], name: "index_income_sources_on_user_id"
  end

  create_table "investments", force: :cascade do |t|
    t.string "name"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.date "invested_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_investments_on_user_id"
  end

  create_table "recurring_expense_records", force: :cascade do |t|
    t.bigint "recurring_expense_id", null: false
    t.date "month"
    t.integer "actual_amount_cents"
    t.string "actual_amount_currency"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "paid_date"
    t.bigint "income_source_id"
    t.index ["income_source_id"], name: "index_recurring_expense_records_on_income_source_id"
    t.index ["recurring_expense_id"], name: "index_recurring_expense_records_on_recurring_expense_id"
  end

  create_table "recurring_expenses", force: :cascade do |t|
    t.string "name"
    t.integer "estimated_amount_cents"
    t.string "estimated_amount_currency"
    t.integer "due_day"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.index ["user_id"], name: "index_recurring_expenses_on_user_id"
  end

  create_table "recurring_income_records", force: :cascade do |t|
    t.bigint "recurring_income_id", null: false
    t.date "month"
    t.integer "actual_amount_cents"
    t.string "actual_amount_currency"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "received_date"
    t.index ["recurring_income_id"], name: "index_recurring_income_records_on_recurring_income_id"
  end

  create_table "recurring_incomes", force: :cascade do |t|
    t.string "name"
    t.integer "estimated_amount_cents"
    t.string "estimated_amount_currency"
    t.integer "due_day"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.string "source"
    t.index ["user_id"], name: "index_recurring_incomes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "income_sources"
  add_foreign_key "expenses", "users"
  add_foreign_key "income_sources", "users"
  add_foreign_key "investments", "users"
  add_foreign_key "recurring_expense_records", "income_sources"
  add_foreign_key "recurring_expense_records", "recurring_expenses"
  add_foreign_key "recurring_expenses", "users"
  add_foreign_key "recurring_income_records", "recurring_incomes"
  add_foreign_key "recurring_incomes", "users"
end
