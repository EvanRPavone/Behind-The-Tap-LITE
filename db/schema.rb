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

ActiveRecord::Schema[7.1].define(version: 2025_01_26_193609) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addition_logs", force: :cascade do |t|
    t.bigint "brew_id", null: false
    t.bigint "hop_addition_1_id"
    t.bigint "hop_addition_2_id"
    t.string "other_additions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.decimal "hop_addition_1_amount", precision: 10, scale: 2
    t.decimal "hop_addition_2_amount", precision: 10, scale: 2
    t.text "notes"
    t.index ["brew_id"], name: "index_addition_logs_on_brew_id"
    t.index ["user_id"], name: "index_addition_logs_on_user_id"
  end

  create_table "boil_logs", force: :cascade do |t|
    t.bigint "brew_id", null: false
    t.datetime "vorlauf_start_time"
    t.datetime "vorlauf_complete_time"
    t.datetime "sparge_start_time"
    t.decimal "sparge_amount"
    t.datetime "sparge_complete_time"
    t.datetime "kettle_full_time"
    t.decimal "preboil_volume"
    t.decimal "preboil_gravity"
    t.decimal "preboil_ph"
    t.datetime "boil_achieved_time"
    t.datetime "boil_complete_time"
    t.decimal "post_boil_amount"
    t.decimal "post_boil_gravity"
    t.decimal "post_boil_ph"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.decimal "original_grav", precision: 5, scale: 3
    t.text "notes"
    t.string "stage", default: "preboil", null: false
    t.index ["brew_id"], name: "index_boil_logs_on_brew_id"
    t.index ["user_id"], name: "index_boil_logs_on_user_id"
  end

  create_table "brews", force: :cascade do |t|
    t.string "batch_no"
    t.string "in_tank"
    t.integer "status"
    t.date "brew_date"
    t.decimal "target_p"
    t.integer "vessel_id"
    t.datetime "d_rest_start"
    t.datetime "crash_start"
    t.date "target_release"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.decimal "int_sg", precision: 5, scale: 3, default: "1.0"
    t.decimal "current_sg", precision: 5, scale: 3, default: "1.0"
    t.decimal "est_abv", precision: 5, scale: 2
    t.decimal "target_carbed_vol", precision: 5, scale: 2
    t.index ["company_id"], name: "index_brews_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "partner_companies", default: [], array: true
    t.string "slug"
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "fermentation_logs", force: :cascade do |t|
    t.bigint "brew_id", null: false
    t.string "status"
    t.decimal "temperature"
    t.decimal "ph"
    t.datetime "log_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "stage"
    t.integer "day"
    t.decimal "plato"
    t.decimal "tank_temp"
    t.string "action"
    t.text "notes"
    t.decimal "carbed_vol"
    t.decimal "og_was"
    t.decimal "og_is"
    t.index ["brew_id"], name: "index_fermentation_logs_on_brew_id"
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

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brand"
    t.string "type_of_unit"
    t.decimal "weight_per_unit", precision: 10, scale: 2
    t.decimal "total_weight", precision: 10, scale: 2
    t.index ["company_id"], name: "index_ingredients_on_company_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email"
    t.string "role"
    t.string "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
  end

  create_table "keg_shares", force: :cascade do |t|
    t.bigint "keg_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_keg_shares_on_company_id"
    t.index ["keg_id"], name: "index_keg_shares_on_keg_id"
  end

  create_table "kegs", force: :cascade do |t|
    t.string "name"
    t.decimal "size", default: "0.0"
    t.string "size_unit"
    t.string "status"
    t.bigint "brew_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "recipe_id"
    t.integer "shared_from"
    t.index ["brew_id"], name: "index_kegs_on_brew_id"
    t.index ["company_id"], name: "index_kegs_on_company_id"
    t.index ["recipe_id"], name: "index_kegs_on_recipe_id"
    t.index ["shared_from"], name: "index_kegs_on_shared_from"
  end

  create_table "mash_logs", force: :cascade do |t|
    t.bigint "brew_id", null: false
    t.datetime "mash_in_time"
    t.datetime "mash_complete_time"
    t.decimal "mash_temp"
    t.decimal "mash_ph"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "notes"
    t.index ["brew_id"], name: "index_mash_logs_on_brew_id"
    t.index ["user_id"], name: "index_mash_logs_on_user_id"
  end

  create_table "partnerships", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "partner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "partner_id"], name: "index_partnerships_on_company_id_and_partner_id", unique: true
    t.index ["company_id"], name: "index_partnerships_on_company_id"
    t.index ["partner_id"], name: "index_partnerships_on_partner_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit_of_measurement"
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.decimal "target_abv", precision: 5, scale: 2
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "size_bbl", precision: 10, scale: 2
    t.index ["company_id"], name: "index_recipes_on_company_id"
  end

  create_table "steps", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.integer "company_id"
    t.string "first_name"
    t.string "last_name"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "invitation_token"
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vessels", force: :cascade do |t|
    t.string "name"
    t.decimal "size_bbl", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.boolean "in_use", default: false, null: false
  end

  create_table "yeast_and_knockout_logs", force: :cascade do |t|
    t.bigint "brew_id", null: false
    t.datetime "whirlpool_start_time"
    t.datetime "knockout_start_time"
    t.datetime "knockout_end_time"
    t.decimal "trub_volume"
    t.string "yeast_source"
    t.string "yeast_id"
    t.integer "yeast_generation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "notes"
    t.index ["brew_id"], name: "index_yeast_and_knockout_logs_on_brew_id"
    t.index ["user_id"], name: "index_yeast_and_knockout_logs_on_user_id"
  end

  add_foreign_key "addition_logs", "brews"
  add_foreign_key "addition_logs", "ingredients", column: "hop_addition_1_id"
  add_foreign_key "addition_logs", "ingredients", column: "hop_addition_2_id"
  add_foreign_key "boil_logs", "brews"
  add_foreign_key "fermentation_logs", "brews"
  add_foreign_key "ingredients", "companies"
  add_foreign_key "keg_shares", "companies"
  add_foreign_key "keg_shares", "kegs"
  add_foreign_key "kegs", "brews"
  add_foreign_key "kegs", "companies"
  add_foreign_key "kegs", "recipes"
  add_foreign_key "mash_logs", "brews"
  add_foreign_key "partnerships", "companies"
  add_foreign_key "partnerships", "companies", column: "partner_id"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "companies"
  add_foreign_key "yeast_and_knockout_logs", "brews"
end
