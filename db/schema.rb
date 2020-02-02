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

ActiveRecord::Schema.define(version: 20200202042444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acad_entity_scores", force: :cascade do |t|
    t.decimal "average"
    t.decimal "maximum"
    t.decimal "last"
    t.time "time_spent"
    t.integer "passed_count"
    t.integer "failed_count"
    t.integer "seen_count"
    t.decimal "percentile"
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.bigint "session_score_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_acad_entity_scores_on_acad_entity_type_and_acad_entity_id"
    t.index ["session_score_id"], name: "index_acad_entity_scores_on_session_score_id"
    t.index ["user_id"], name: "index_acad_entity_scores_on_user_id"
  end

  create_table "acad_profiles", force: :cascade do |t|
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "in_game", default: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_acad_profiles_on_acad_entity_type_and_acad_entity_id"
    t.index ["user_id"], name: "index_acad_profiles_on_user_id"
  end

  create_table "acad_standings", force: :cascade do |t|
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_acad_standings_on_acad_entity_type_and_acad_entity_id"
    t.index ["user_id"], name: "index_acad_standings_on_user_id"
  end

  create_table "attempt_scores", force: :cascade do |t|
    t.string "attempt_item_type"
    t.bigint "attempt_item_id"
    t.boolean "displayed"
    t.integer "time_spent"
    t.boolean "passed"
    t.integer "tap_count"
    t.string "user_input"
    t.integer "correct_count"
    t.integer "star_count"
    t.integer "normal_marks"
    t.integer "speedy_marks"
    t.integer "complete_set_marks"
    t.integer "actual_answer_marks"
    t.integer "consistency_marks"
    t.integer "remaining_time_marks"
    t.integer "remaining_lives_marks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "alone_box_marks"
    t.integer "minimum_steps_marks"
    t.integer "minimum_cards_marks"
    t.index ["attempt_item_type", "attempt_item_id"], name: "index_attempt_scores_on_attempt_item_type_and_attempt_item_id"
  end

  create_table "benifits", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "explainer"
    t.integer "sequence"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "question_type_id"
    t.index ["question_type_id"], name: "index_benifits_on_question_type_id"
    t.index ["slug"], name: "index_benifits_on_slug", unique: true
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
    t.boolean "enabled", default: false
    t.index ["slug"], name: "index_chapters_on_slug", unique: true
    t.index ["standard_id"], name: "index_chapters_on_standard_id"
    t.index ["stream_id"], name: "index_chapters_on_stream_id"
  end

  create_table "character_dialogs", force: :cascade do |t|
    t.bigint "character_discussion_id"
    t.bigint "character_id"
    t.bigint "left_weapon_id"
    t.string "left_weapon_colour"
    t.bigint "right_weapon_id"
    t.string "right_weapon_colour"
    t.integer "count"
    t.integer "position"
    t.integer "animation"
    t.integer "repeat_mode"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_discussion_id"], name: "index_character_dialogs_on_character_discussion_id"
    t.index ["character_id"], name: "index_character_dialogs_on_character_id"
    t.index ["left_weapon_id"], name: "index_character_dialogs_on_left_weapon_id"
    t.index ["right_weapon_id"], name: "index_character_dialogs_on_right_weapon_id"
  end

  create_table "character_discussions", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_character_discussions_on_slug", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_characters_on_slug", unique: true
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
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.boolean "enabled", default: false
    t.string "title", default: ""
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_game_holders_on_acad_entity_type_and_acad_entity_id"
    t.index ["game_type", "game_id"], name: "index_game_holders_on_game_type_and_game_id"
    t.index ["question_type_id"], name: "index_game_holders_on_question_type_id"
    t.index ["slug"], name: "index_game_holders_on_slug", unique: true
  end

  create_table "game_level_victory_cards", force: :cascade do |t|
    t.bigint "game_level_id"
    t.bigint "victory_card_id"
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_level_id"], name: "index_game_level_victory_cards_on_game_level_id"
    t.index ["victory_card_id"], name: "index_game_level_victory_cards_on_victory_card_id"
  end

  create_table "game_levels", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.bigint "game_holder_id"
    t.integer "practice_mode"
    t.integer "nature_effect"
    t.integer "sequence"
    t.bigint "intro_discussion_id"
    t.bigint "success_discussion_id"
    t.bigint "fail_discussion_id"
    t.integer "standard_sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fail_discussion_id"], name: "index_game_levels_on_fail_discussion_id"
    t.index ["game_holder_id"], name: "index_game_levels_on_game_holder_id"
    t.index ["intro_discussion_id"], name: "index_game_levels_on_intro_discussion_id"
    t.index ["slug"], name: "index_game_levels_on_slug", unique: true
    t.index ["success_discussion_id"], name: "index_game_levels_on_success_discussion_id"
  end

  create_table "game_option_attempts", force: :cascade do |t|
    t.boolean "is_attempted"
    t.boolean "is_attempted_correctly"
    t.string "user_input"
    t.integer "time_attempt"
    t.bigint "game_option_id"
    t.bigint "game_question_attempt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_option_id"], name: "index_game_option_attempts_on_game_option_id"
    t.index ["game_question_attempt_id"], name: "index_game_option_attempts_on_game_question_attempt_id"
  end

  create_table "game_options", force: :cascade do |t|
    t.bigint "option_id"
    t.bigint "game_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_option_id"
    t.integer "position"
    t.bigint "option_type_id"
    t.integer "delete_status", default: 0
    t.index ["game_question_id"], name: "index_game_options_on_game_question_id"
    t.index ["option_id"], name: "index_game_options_on_option_id"
    t.index ["option_type_id"], name: "index_game_options_on_option_type_id"
    t.index ["parent_option_id"], name: "index_game_options_on_parent_option_id"
  end

  create_table "game_question_attempts", force: :cascade do |t|
    t.integer "time_attempt"
    t.boolean "passed"
    t.boolean "attempted"
    t.bigint "game_question_id"
    t.bigint "game_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_question_id"], name: "index_game_question_attempts_on_game_question_id"
    t.index ["game_session_id"], name: "index_game_question_attempts_on_game_session_id"
  end

  create_table "game_questions", force: :cascade do |t|
    t.integer "difficulty"
    t.integer "time_alloted"
    t.bigint "question_id"
    t.bigint "game_holder_id"
    t.bigint "parent_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "difficulty_index", default: 0
    t.integer "delete_status", default: 0
    t.integer "approval_status", default: 0
    t.index ["game_holder_id"], name: "index_game_questions_on_game_holder_id"
    t.index ["parent_question_id"], name: "index_game_questions_on_parent_question_id"
    t.index ["question_id"], name: "index_game_questions_on_question_id"
  end

  create_table "game_sessions", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.bigint "game_holder_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "end_difficulty_index", default: 0
    t.integer "next_difficulty_index", default: 0
    t.bigint "game_level_id"
    t.index ["game_holder_id"], name: "index_game_sessions_on_game_holder_id"
    t.index ["game_level_id"], name: "index_game_sessions_on_game_level_id"
    t.index ["user_id"], name: "index_game_sessions_on_user_id"
  end

  create_table "hint_contents", force: :cascade do |t|
    t.string "display"
    t.integer "position"
    t.bigint "hint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hint_id"], name: "index_hint_contents_on_hint_id"
  end

  create_table "hints", force: :cascade do |t|
    t.string "value_type"
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_hints_on_acad_entity_type_and_acad_entity_id"
  end

  create_table "marker_gaps", force: :cascade do |t|
    t.integer "big"
    t.integer "small"
    t.integer "tiny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_types", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "upper"
    t.string "lower"
    t.string "hint"
    t.string "display"
    t.string "value"
    t.string "value_type"
    t.string "after_attempt"
    t.integer "sequence"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "display_index"
    t.string "sub_title"
    t.integer "reference_id"
    t.boolean "positive"
  end

  create_table "practice_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "questions", force: :cascade do |t|
    t.string "display"
    t.string "hint"
    t.string "tip"
    t.string "solution"
    t.string "mode"
    t.bigint "parent_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "marker_gap_id"
    t.integer "steps"
    t.string "setup"
    t.integer "position"
    t.index ["marker_gap_id"], name: "index_questions_on_marker_gap_id"
    t.index ["parent_question_id"], name: "index_questions_on_parent_question_id"
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

  create_table "region_percentile_scores", force: :cascade do |t|
    t.integer "percentile_count"
    t.decimal "score"
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_region_percentile_scores_on_acad_entity"
    t.index ["region_id"], name: "index_region_percentile_scores_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "region_type"
    t.bigint "parent_region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_region_id"], name: "index_regions_on_parent_region_id"
    t.index ["slug"], name: "index_regions_on_slug", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  create_table "score_structures", force: :cascade do |t|
    t.bigint "game_holder_id"
    t.integer "limiter_time_question"
    t.integer "limiter_time_game"
    t.integer "limiter_option"
    t.integer "limiter_question"
    t.integer "limiter_lives"
    t.integer "marks_normal_attempt"
    t.integer "marks_normal_time"
    t.integer "marks_speedy_time_limit"
    t.integer "marks_speedy_max"
    t.integer "marks_complete_set"
    t.integer "marks_remaining_lives"
    t.integer "marks_actual_answer"
    t.integer "marks_consistency_bonus"
    t.integer "marks_remaining_time"
    t.integer "star_threshold_2"
    t.integer "star_threshold_3"
    t.boolean "display_report_accuracy", default: false
    t.boolean "display_report_content", default: false
    t.boolean "display_remaining_lives", default: false
    t.boolean "display_speedy_answer", default: false
    t.boolean "display_perfect_set", default: false
    t.boolean "display_longest_streak", default: false
    t.boolean "display_accurate_answer", default: false
    t.boolean "display_errors", default: false
    t.boolean "display_remaining_time", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "marks_alone_box"
    t.integer "marks_minimum_steps"
    t.integer "marks_minimum_cards"
    t.index ["game_holder_id"], name: "index_score_structures_on_game_holder_id"
  end

  create_table "session_scores", force: :cascade do |t|
    t.decimal "value"
    t.integer "correct_count"
    t.integer "incorrect_count"
    t.boolean "seen"
    t.boolean "passed"
    t.boolean "failed"
    t.bigint "game_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_taken"
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
    t.boolean "enabled", default: false
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
    t.boolean "enabled", default: false
    t.index ["chapter_id"], name: "index_topics_on_chapter_id"
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "user_regions", force: :cascade do |t|
    t.date "registration_date"
    t.bigint "user_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_user_regions_on_region_id"
    t.index ["user_id"], name: "index_user_regions_on_user_id"
  end

  create_table "user_victory_cards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "victory_card_id"
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_victory_cards_on_user_id"
    t.index ["victory_card_id"], name: "index_user_victory_cards_on_victory_card_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: ""
    t.string "last_name", default: ""
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
    t.string "verification_code", default: "f"
    t.boolean "is_verified"
    t.integer "sex"
    t.date "birth"
    t.integer "registration_method"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "victory_cards", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "acad_entity_type"
    t.bigint "acad_entity_id"
    t.string "title"
    t.string "description"
    t.integer "max_count"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acad_entity_type", "acad_entity_id"], name: "index_victory_cards_on_acad_entity_type_and_acad_entity_id"
    t.index ["slug"], name: "index_victory_cards_on_slug", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_weapons_on_slug", unique: true
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

  add_foreign_key "acad_entity_scores", "session_scores"
  add_foreign_key "acad_entity_scores", "users"
  add_foreign_key "acad_profiles", "users"
  add_foreign_key "acad_standings", "users"
  add_foreign_key "benifits", "question_types"
  add_foreign_key "chapters", "standards"
  add_foreign_key "chapters", "streams"
  add_foreign_key "character_dialogs", "character_discussions"
  add_foreign_key "character_dialogs", "characters"
  add_foreign_key "character_dialogs", "weapons", column: "left_weapon_id"
  add_foreign_key "character_dialogs", "weapons", column: "right_weapon_id"
  add_foreign_key "game_holders", "question_types"
  add_foreign_key "game_level_victory_cards", "game_levels"
  add_foreign_key "game_level_victory_cards", "victory_cards"
  add_foreign_key "game_levels", "character_discussions", column: "fail_discussion_id"
  add_foreign_key "game_levels", "character_discussions", column: "intro_discussion_id"
  add_foreign_key "game_levels", "character_discussions", column: "success_discussion_id"
  add_foreign_key "game_levels", "game_holders"
  add_foreign_key "game_option_attempts", "game_options"
  add_foreign_key "game_option_attempts", "game_question_attempts"
  add_foreign_key "game_options", "game_questions"
  add_foreign_key "game_options", "option_types"
  add_foreign_key "game_options", "options"
  add_foreign_key "game_question_attempts", "game_questions"
  add_foreign_key "game_question_attempts", "game_sessions"
  add_foreign_key "game_questions", "game_holders"
  add_foreign_key "game_questions", "questions"
  add_foreign_key "game_sessions", "game_holders"
  add_foreign_key "game_sessions", "game_levels"
  add_foreign_key "game_sessions", "users"
  add_foreign_key "hint_contents", "hints"
  add_foreign_key "question_types", "sub_topics"
  add_foreign_key "questions", "marker_gaps"
  add_foreign_key "region_percentile_scores", "regions"
  add_foreign_key "score_structures", "game_holders"
  add_foreign_key "session_scores", "game_sessions"
  add_foreign_key "streams", "subjects"
  add_foreign_key "sub_topics", "topics"
  add_foreign_key "topics", "chapters"
  add_foreign_key "user_regions", "regions"
  add_foreign_key "user_regions", "users"
  add_foreign_key "user_victory_cards", "users"
  add_foreign_key "user_victory_cards", "victory_cards"
  add_foreign_key "users", "roles"
  add_foreign_key "working_rules", "difficulty_levels"
end
