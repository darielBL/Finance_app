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

ActiveRecord::Schema[8.0].define(version: 2026_06_14_000001) do
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

  create_table "debts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "debt_type", null: false
    t.string "person_name"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.date "due_date"
    t.date "paid_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "debt_type"], name: "index_debts_on_user_id_and_debt_type"
    t.index ["user_id", "paid_at"], name: "index_debts_on_user_id_and_paid_at"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.date "date", null: false
    t.decimal "usd_cup", precision: 10, scale: 2
    t.decimal "eur_cup", precision: 10, scale: 2
    t.decimal "cla_cup", precision: 10, scale: 2
    t.decimal "zelle_cup", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_exchange_rates_on_date", unique: true
  end

  create_table "expense_records", force: :cascade do |t|
    t.date "month"
    t.integer "actual_amount_cents"
    t.string "actual_amount_currency"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "paid_date"
    t.bigint "income_source_id", null: false
    t.bigint "expense_id", null: false
    t.index ["expense_id"], name: "index_expense_records_on_expense_id"
    t.index ["income_source_id"], name: "index_expense_records_on_income_source_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "description"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.date "spent_at"
    t.bigint "category_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "income_source_id", null: false
    t.string "name"
    t.boolean "recurring", default: false, null: false
    t.integer "due_day"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["income_source_id"], name: "index_expenses_on_income_source_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "goal_contributions", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", default: "CUP", null: false
    t.date "contributed_at", null: false
    t.text "notes"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goal_contributions_on_goal_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "target_amount_cents", null: false
    t.string "target_amount_currency", default: "CUP", null: false
    t.date "deadline"
    t.text "description"
    t.string "status", default: "in_progress", null: false
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "income_records", force: :cascade do |t|
    t.date "month"
    t.integer "actual_amount_cents"
    t.string "actual_amount_currency"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "received_date"
    t.bigint "income_id", null: false
    t.index ["income_id"], name: "index_income_records_on_income_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.string "name"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.boolean "recurring", default: false, null: false
    t.integer "due_day"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_incomes_on_user_id"
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

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "notification_type", null: false
    t.string "title", null: false
    t.text "message"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "source_transfers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "from_source", null: false
    t.string "to_source", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", default: "CUP", null: false
    t.date "transferred_at", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_source_transfers_on_user_id"
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
  add_foreign_key "debts", "users"
  add_foreign_key "expense_records", "expenses"
  add_foreign_key "expense_records", "incomes", column: "income_source_id"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "incomes", column: "income_source_id"
  add_foreign_key "expenses", "users"
  add_foreign_key "goal_contributions", "goals"
  add_foreign_key "goals", "users"
  add_foreign_key "income_records", "incomes"
  add_foreign_key "incomes", "users"
  add_foreign_key "investments", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "source_transfers", "users"
end
