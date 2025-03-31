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

ActiveRecord::Schema[8.0].define(version: 2025_03_27_101430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "format", ["video", "audio", "text"]

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

  create_table "challenges", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_challenges_on_owner_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "token_digest"
    t.bigint "hypothesis_id", null: false
    t.bigint "evaluator_id", null: false
    t.integer "status", default: 0, null: false
    t.string "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "error_message"
    t.index ["evaluator_id"], name: "index_evaluations_on_evaluator_id"
    t.index ["hypothesis_id", "evaluator_id"], name: "index_evaluations_on_hypothesis_id_and_evaluator_id", unique: true
    t.index ["hypothesis_id"], name: "index_evaluations_on_hypothesis_id"
  end

  create_table "evaluators", force: :cascade do |t|
    t.string "name", null: false
    t.text "script", null: false
    t.string "host", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "from", enum_type: "format"
    t.enum "to", enum_type: "format"
  end

  create_table "hypotheses", force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "test_set_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id", "test_set_entry_id"], name: "index_hypotheses_on_model_id_and_test_set_entry_id", unique: true
    t.index ["model_id"], name: "index_hypotheses_on_model_id"
    t.index ["test_set_entry_id"], name: "index_hypotheses_on_test_set_entry_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name"
    t.bigint "evaluator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
    t.index ["evaluator_id"], name: "index_metrics_on_evaluator_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenge_id"
    t.index ["challenge_id"], name: "index_models_on_challenge_id"
    t.index ["owner_id"], name: "index_models_on_owner_id"
  end

  create_table "scores", force: :cascade do |t|
    t.float "value"
    t.bigint "metric_id", null: false
    t.bigint "evaluation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_scores_on_evaluation_id"
    t.index ["metric_id", "evaluation_id"], name: "index_scores_on_metric_id_and_evaluation_id", unique: true
    t.index ["metric_id"], name: "index_scores_on_metric_id"
  end

  create_table "task_evaluators", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "evaluator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluator_id"], name: "index_task_evaluators_on_evaluator_id"
    t.index ["task_id", "evaluator_id"], name: "index_task_evaluators_on_task_id_and_evaluator_id", unique: true
    t.index ["task_id"], name: "index_task_evaluators_on_task_id"
  end

  create_table "task_models", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "model_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id"], name: "index_task_models_on_model_id"
    t.index ["task_id", "model_id"], name: "index_task_models_on_task_id_and_model_id", unique: true
    t.index ["task_id"], name: "index_task_models_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.text "info"
    t.string "slug"
    t.enum "from", null: false, enum_type: "format"
    t.enum "to", null: false, enum_type: "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenge_id"
    t.index ["challenge_id"], name: "index_tasks_on_challenge_id"
  end

  create_table "test_set_entries", force: :cascade do |t|
    t.string "source_language", null: false
    t.string "target_language", null: false
    t.bigint "test_set_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_language", "target_language", "test_set_id", "task_id"], name: "idx_on_source_language_target_language_test_set_id__e10c5b6230", unique: true
    t.index ["task_id"], name: "index_test_set_entries_on_task_id"
    t.index ["test_set_id"], name: "index_test_set_entries_on_test_set_id"
  end

  create_table "test_sets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.bigint "challenge_id"
    t.index ["challenge_id"], name: "index_test_sets_on_challenge_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "plgrid_login"
    t.string "email"
    t.string "uid"
    t.integer "roles_mask", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "ssh_key"
    t.text "ssh_certificate"
    t.string "provider"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "challenges", "users", column: "owner_id"
  add_foreign_key "evaluations", "evaluators"
  add_foreign_key "evaluations", "hypotheses"
  add_foreign_key "hypotheses", "models"
  add_foreign_key "hypotheses", "test_set_entries"
  add_foreign_key "metrics", "evaluators"
  add_foreign_key "models", "users", column: "owner_id"
  add_foreign_key "scores", "evaluations"
  add_foreign_key "scores", "metrics"
  add_foreign_key "task_models", "models"
  add_foreign_key "task_models", "tasks"
  add_foreign_key "tasks", "challenges"
  add_foreign_key "test_set_entries", "tasks"
  add_foreign_key "test_set_entries", "test_sets"
  add_foreign_key "test_sets", "challenges"
end
