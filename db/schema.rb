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

ActiveRecord::Schema[7.2].define(version: 2024_04_25_132715) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "format", ["movie", "text"]

  create_table "model_benchmarks", force: :cascade do |t|
    t.string "name"
    t.bigint "model_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_type_id"], name: "index_model_benchmarks_on_model_type_id"
  end

  create_table "model_benchmarks_metrics", force: :cascade do |t|
    t.string "name"
    t.bigint "benchmark_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benchmark_id"], name: "index_model_benchmarks_metrics_on_benchmark_id"
  end

  create_table "model_types", force: :cascade do |t|
    t.string "name"
    t.enum "from", null: false, enum_type: "format"
    t.enum "to", null: false, enum_type: "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.bigint "model_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_type_id"], name: "index_models_on_model_type_id"
  end

  create_table "models_scores", force: :cascade do |t|
    t.float "value"
    t.bigint "model_id", null: false
    t.bigint "metric_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id"], name: "index_models_scores_on_metric_id"
    t.index ["model_id"], name: "index_models_scores_on_model_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "plgrid_login"
    t.string "email"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "model_benchmarks", "model_types"
  add_foreign_key "model_benchmarks_metrics", "model_benchmarks", column: "benchmark_id"
  add_foreign_key "models", "model_types"
  add_foreign_key "models_scores", "model_benchmarks_metrics", column: "metric_id"
  add_foreign_key "models_scores", "models"
end
