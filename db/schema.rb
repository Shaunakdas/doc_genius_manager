# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171024150652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acad_profiles", force: :cascade do |t|
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_acad_profiles_on_acad_entity_type_and_acad_entity_id"
    t.index ["user_id"], name: "index_acad_profiles_on_user_id"
  end

  create_table "benefits", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "explainer"
    t.integer "sequence"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_benefits_on_slug", unique: true
  end

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence_stream"
    t.integer "sequence_standard"
    t.bigint "standard_id"
    t.bigint "stream_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_chapters_on_slug", unique: true
    t.index ["standard_id"], name: "index_chapters_on_standard_id"
    t.index ["stream_id"], name: "index_chapters_on_stream_id"
  end

  create_table "difficulty_levels", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_difficulty_levels_on_slug", unique: true
  end

  create_table "game_holders", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.string "game_type"
    t.bigint "game_id"
    t.string "image_url"
    t.bigint "question_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_type", "game_id"], name: "index_game_holders_on_game_type_and_game_id"
    t.index ["question_type_id"], name: "index_game_holders_on_question_type_id"
    t.index ["slug"], name: "index_game_holders_on_slug", unique: true
  end

  create_table "game_sessions", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.bigint "game_holder_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_holder_id"], name: "index_game_sessions_on_game_holder_id"
    t.index ["user_id"], name: "index_game_sessions_on_user_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.string "image_url"
    t.bigint "sub_topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_question_types_on_slug", unique: true
    t.index ["sub_topic_id"], name: "index_question_types_on_sub_topic_id"
  end

  create_table "rank_names", force: :cascade do |t|
    t.string "slug"
    t.integer "sequence"
    t.string "display_text"
    t.string "explainer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_rank_names_on_slug", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  create_table "session_scores", force: :cascade do |t|
    t.decimal "value"
    t.time "time_taken"
    t.integer "correct_count"
    t.integer "incorrect_count"
    t.boolean "seen"
    t.boolean "passed"
    t.boolean "failed"
    t.bigint "game_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_session_scores_on_game_session_id"
  end

  create_table "standards", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_standards_on_slug", unique: true
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.bigint "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_streams_on_slug", unique: true
    t.index ["subject_id"], name: "index_streams_on_subject_id"
  end

  create_table "sub_topics", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.bigint "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_sub_topics_on_slug", unique: true
    t.index ["topic_id"], name: "index_sub_topics_on_topic_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_subjects_on_slug", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.bigint "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_topics_on_chapter_id"
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.string "mobile_number"
    t.string "verification_code"
    t.boolean "is_verified"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "working_rules", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "sequence"
    t.string "question_text"
    t.bigint "difficulty_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["difficulty_level_id"], name: "index_working_rules_on_difficulty_level_id"
    t.index ["slug"], name: "index_working_rules_on_slug", unique: true
  end

  add_foreign_key "acad_profiles", "users"
  add_foreign_key "chapters", "standards"
  add_foreign_key "chapters", "streams"
  add_foreign_key "game_holders", "question_types"
  add_foreign_key "game_sessions", "game_holders"
  add_foreign_key "game_sessions", "users"
  add_foreign_key "question_types", "sub_topics"
  add_foreign_key "session_scores", "game_sessions"
  add_foreign_key "streams", "subjects"
  add_foreign_key "sub_topics", "topics"
  add_foreign_key "topics", "chapters"
  add_foreign_key "users", "roles"
  add_foreign_key "working_rules", "difficulty_levels"
end
