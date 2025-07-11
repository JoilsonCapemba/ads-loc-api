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

ActiveRecord::Schema[8.0].define(version: 2025_06_27_232252) do
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

  create_table "anuncios", force: :cascade do |t|
    t.string "titulo"
    t.text "descricao"
    t.bigint "local_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "perfil_id"
    t.string "tag_descricao"
    t.index ["local_id"], name: "index_anuncios_on_local_id"
    t.index ["perfil_id"], name: "index_anuncios_on_perfil_id"
    t.index ["user_id"], name: "index_anuncios_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id", "user2_id"], name: "index_chats_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_chats_on_user1_id"
    t.index ["user2_id"], name: "index_chats_on_user2_id"
  end

  create_table "coordenadas", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "raio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locals", force: :cascade do |t|
    t.string "nome"
    t.bigint "coordenada_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordenada_id"], name: "index_locals_on_coordenada_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "sender_id", null: false
    t.text "content"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "created_at"], name: "index_messages_on_chat_id_and_created_at"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["sender_id", "read"], name: "index_messages_on_sender_id_and_read"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "perfils", force: :cascade do |t|
    t.string "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfils_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "perfil_id", null: false
    t.index ["perfil_id", "user_id"], name: "index_perfils_users_on_perfil_id_and_user_id"
    t.index ["user_id", "perfil_id"], name: "index_perfils_users_on_user_id_and_perfil_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "username"
    t.string "full_name"
    t.float "saldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "local_id"
    t.index ["local_id"], name: "index_users_on_local_id"
  end

  create_table "users_perfils", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "Perfil_id"
    t.index ["Perfil_id"], name: "index_users_perfils_on_Perfil_id"
    t.index ["user_id"], name: "index_users_perfils_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "anuncios", "locals"
  add_foreign_key "anuncios", "perfils"
  add_foreign_key "anuncios", "users"
  add_foreign_key "chats", "users", column: "user1_id"
  add_foreign_key "chats", "users", column: "user2_id"
  add_foreign_key "locals", "coordenadas"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "users", "locals"
end
