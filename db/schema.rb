# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_27_133211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.bigint "planning_application_id"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["planning_application_id"], name: "index_audits_on_planning_application_id"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "developments", force: :cascade do |t|
    t.string "application_number"
    t.string "site_address"
    t.text "proposal"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state", default: "draft", null: false
    t.string "developer_access_key"
    t.string "name"
    t.string "developer"
    t.string "rp_access_key"
    t.date "agreed_on"
    t.date "started_on"
    t.bigint "scheme_id"
    t.index ["scheme_id"], name: "index_developments_on_scheme_id"
  end

  create_table "dwellings", force: :cascade do |t|
    t.string "tenure"
    t.integer "habitable_rooms"
    t.integer "bedrooms"
    t.bigint "development_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.bigint "registered_provider_id"
    t.string "reference_id"
    t.boolean "studio", default: false, null: false
    t.string "rp_internal_id"
    t.boolean "wheelchair_accessible", default: false, null: false
    t.boolean "wheelchair_adaptable", default: false, null: false
    t.string "uprn"
    t.string "tenure_product"
    t.index ["development_id"], name: "index_dwellings_on_development_id"
    t.index ["registered_provider_id"], name: "index_dwellings_on_registered_provider_id"
  end

  create_table "planning_applications", force: :cascade do |t|
    t.string "application_number"
    t.bigint "development_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["development_id"], name: "index_planning_applications_on_development_id"
  end

  create_table "registered_providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schemes", force: :cascade do |t|
    t.string "name"
    t.string "application_number"
    t.string "site_address"
    t.text "proposal"
    t.string "developer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "audits", "planning_applications"
  add_foreign_key "developments", "schemes"
  add_foreign_key "dwellings", "developments"
  add_foreign_key "dwellings", "registered_providers"
  add_foreign_key "planning_applications", "developments"
end
