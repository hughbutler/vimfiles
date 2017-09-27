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

ActiveRecord::Schema.define(version: 20170813130013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attribute_answers", force: :cascade do |t|
    t.integer  "attribute_id"
    t.string   "title",             limit: 255
    t.integer  "person_id"
    t.integer  "attributable_id"
    t.integer  "integer"
    t.string   "attributable_type", limit: 255
    t.string   "string",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attributable_id"], name: "index_attribute_answers_on_attributable_id", using: :btree
    t.index ["attribute_id"], name: "index_attribute_answers_on_attribute_id", using: :btree
    t.index ["person_id"], name: "index_attribute_answers_on_person_id", using: :btree
  end

  create_table "attribute_positions", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "tag",   limit: 255
  end

  create_table "attribute_types", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "tag",   limit: 255
  end

  create_table "attribute_values", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.integer  "attribute_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attribute_id"], name: "index_attribute_values_on_attribute_id", using: :btree
  end

  create_table "attributes", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.string   "hint_field",            limit: 255
    t.boolean  "is_searchable"
    t.integer  "attribute_type_id"
    t.integer  "community_id"
    t.integer  "attribute_position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attribute_position_id"], name: "index_attributes_on_attribute_position_id", using: :btree
    t.index ["attribute_type_id"], name: "index_attributes_on_attribute_type_id", using: :btree
    t.index ["community_id"], name: "index_attributes_on_community_id", using: :btree
  end

  create_table "communities", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "street",       limit: 255
    t.string   "city",         limit: 255
    t.integer  "state_id"
    t.string   "postal",       limit: 255
    t.string   "phone",        limit: 255
    t.string   "email",        limit: 255
    t.string   "url",          limit: 255
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_prefix", limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "mail_templates", force: :cascade do |t|
    t.integer  "community_id"
    t.text     "blurb"
    t.string   "context",      limit: 255
    t.string   "subject",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_address", limit: 255
    t.index ["community_id"], name: "index_mail_templates_on_community_id", using: :btree
  end

  create_table "marriages", force: :cascade do |t|
    t.integer  "person_id_male"
    t.integer  "person_id_female"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id_female"], name: "index_marriages_on_person_id_female", using: :btree
    t.index ["person_id_male"], name: "index_marriages_on_person_id_male", using: :btree
  end

  create_table "member_statuses", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "tag",   limit: 255
  end

  create_table "mo_afters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifiers", force: :cascade do |t|
    t.integer  "role_id"
    t.string   "action",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["role_id"], name: "index_notifiers_on_role_id", using: :btree
  end

  create_table "outside_position_logs", force: :cascade do |t|
    t.string   "community",   limit: 255
    t.string   "weekend",     limit: 255
    t.integer  "position_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_outside_position_logs_on_person_id", using: :btree
    t.index ["position_id"], name: "index_outside_position_logs_on_position_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name",                  limit: 255
    t.string   "last_name",                   limit: 255
    t.string   "email",                       limit: 255
    t.string   "gender",                      limit: 255
    t.string   "name_on_tag",                 limit: 255
    t.string   "street",                      limit: 255
    t.string   "city",                        limit: 255
    t.integer  "state_id"
    t.string   "postal",                      limit: 255
    t.string   "main_phone",                  limit: 255
    t.string   "mobile_phone",                limit: 255
    t.boolean  "is_married"
    t.string   "spouse_name",                 limit: 255
    t.string   "emergency_contact_name",      limit: 255
    t.string   "emergency_contact_phone",     limit: 255
    t.string   "church_name",                 limit: 255
    t.boolean  "is_clergy",                               default: false
    t.date     "birthdate"
    t.string   "who_pays",                    limit: 255
    t.text     "notes"
    t.integer  "member_status_id",                        default: 1
    t.boolean  "wants_to_attend",                         default: false
    t.integer  "community_id"
    t.integer  "weekend_id"
    t.integer  "role_id"
    t.integer  "nomination_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "event_attendees_count",                   default: 0
    t.integer  "meeting_attendees_count",                 default: 0
    t.integer  "outside_position_logs_count",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attend_last_minute",                      default: false
    t.boolean  "has_paid",                                default: false
    t.string   "shirt_size",                  limit: 255
    t.string   "sponsorship_training",        limit: 255
    t.string   "birth_weekend_alt",           limit: 255
    t.index ["community_id"], name: "index_people_on_community_id", using: :btree
    t.index ["member_status_id"], name: "index_people_on_member_status_id", using: :btree
    t.index ["nomination_id"], name: "index_people_on_nomination_id", using: :btree
    t.index ["role_id"], name: "index_people_on_role_id", using: :btree
    t.index ["weekend_id"], name: "index_people_on_weekend_id", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.boolean  "read",                   default: false
    t.boolean  "write",                  default: false
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.integer  "community_id"
    t.boolean  "category_1",               default: false
    t.boolean  "category_2",               default: false
    t.boolean  "category_3",               default: false
    t.boolean  "deleted",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "category_4",               default: false
  end

  create_table "pre_weekend_statuses", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "tag",   limit: 255
  end

  create_table "roles", force: :cascade do |t|
    t.string   "long",       limit: 255
    t.string   "short",      limit: 255
    t.integer  "sort",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsorship_types", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "tag",   limit: 255
  end

  create_table "states", force: :cascade do |t|
    t.string "long",  limit: 255
    t.string "short", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reset_password_sent_at"
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "weekend_attendees", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "position_id"
    t.integer  "weekend_id"
    t.boolean  "attended",                          default: true
    t.boolean  "fa_needed",                         default: false
    t.string   "fa_amount_needed",      limit: 255
    t.boolean  "fa_granted",                        default: false
    t.string   "fa_amount_granted",     limit: 255
    t.integer  "pre_weekend_status_id",             default: 1
    t.boolean  "last_minute",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                            default: true
    t.integer  "aux_position_id"
    t.index ["aux_position_id"], name: "index_weekend_attendees_on_aux_position_id", using: :btree
    t.index ["person_id"], name: "index_weekend_attendees_on_person_id", using: :btree
    t.index ["position_id"], name: "index_weekend_attendees_on_position_id", using: :btree
    t.index ["pre_weekend_status_id"], name: "index_weekend_attendees_on_pre_weekend_status_id", using: :btree
    t.index ["weekend_id"], name: "index_weekend_attendees_on_weekend_id", using: :btree
  end

  create_table "weekend_general_funds", force: :cascade do |t|
    t.integer  "weekend_id",                                     null: false
    t.decimal  "amount",                 precision: 8, scale: 2, null: false
    t.string   "note",       limit: 255
    t.integer  "person_id",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["weekend_id"], name: "index_weekend_general_funds_on_weekend_id", using: :btree
  end

  create_table "weekend_meeting_attendees", force: :cascade do |t|
    t.integer  "meeting_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["meeting_id"], name: "index_weekend_meeting_attendees_on_meeting_id", using: :btree
    t.index ["person_id"], name: "index_weekend_meeting_attendees_on_person_id", using: :btree
  end

  create_table "weekend_meetings", force: :cascade do |t|
    t.integer  "weekend_id"
    t.integer  "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["weekend_id"], name: "index_weekend_meetings_on_weekend_id", using: :btree
  end

  create_table "weekend_nominations", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "sponsorship_type_id"
    t.string   "main_phone",                 limit: 255
    t.string   "street",                     limit: 255
    t.string   "city",                       limit: 255
    t.integer  "state_id"
    t.string   "postal",                     limit: 255
    t.boolean  "is_accepted",                            default: false
    t.string   "m_first_name",               limit: 255
    t.string   "m_last_name",                limit: 255
    t.date     "m_birthdate"
    t.string   "m_mobile_phone",             limit: 255
    t.string   "m_email",                    limit: 255
    t.string   "m_church_name",              limit: 255
    t.boolean  "m_is_clergy",                            default: false
    t.text     "m_notes"
    t.boolean  "m_wants_to_attend",                      default: false
    t.integer  "m_weekend_id"
    t.string   "f_first_name",               limit: 255
    t.string   "f_last_name",                limit: 255
    t.date     "f_birthdate"
    t.string   "f_mobile_phone",             limit: 255
    t.string   "f_email",                    limit: 255
    t.string   "f_church_name",              limit: 255
    t.boolean  "f_is_clergy",                            default: false
    t.text     "f_notes"
    t.boolean  "f_wants_to_attend",                      default: false
    t.integer  "f_weekend_id"
    t.integer  "community_id"
    t.string   "who_pays",                   limit: 255
    t.boolean  "is_married",                             default: false
    t.string   "spouse_name",                limit: 255
    t.boolean  "m_last_minute",                          default: false
    t.boolean  "f_last_minute",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "m_shirt_size",               limit: 255
    t.string   "m_emergency_contact_number", limit: 255
    t.string   "f_shirt_size",               limit: 255
    t.string   "f_emergency_contact_number", limit: 255
    t.string   "f_emergency_contact_name",   limit: 255
    t.string   "m_emergency_contact_name",   limit: 255
    t.index ["community_id"], name: "index_weekend_nominations_on_community_id", using: :btree
    t.index ["f_weekend_id"], name: "index_weekend_nominations_on_f_weekend_id", using: :btree
    t.index ["m_weekend_id"], name: "index_weekend_nominations_on_m_weekend_id", using: :btree
    t.index ["person_id"], name: "index_weekend_nominations_on_person_id", using: :btree
    t.index ["sponsorship_type_id"], name: "index_weekend_nominations_on_sponsorship_type_id", using: :btree
  end

  create_table "weekend_payments", force: :cascade do |t|
    t.integer  "community_id"
    t.integer  "person_id",                                                          null: false
    t.integer  "weekend_id"
    t.string   "payment_type", limit: 255,                                           null: false
    t.decimal  "amount",                   precision: 10, scale: 2
    t.boolean  "deleted",                                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note",         limit: 255
    t.string   "source",       limit: 255,                          default: "self"
    t.string   "token",        limit: 255
    t.index ["source"], name: "index_weekend_payments_on_source", using: :btree
    t.index ["weekend_id"], name: "index_weekend_payments_on_weekend_id", using: :btree
  end

  create_table "weekend_team_apps", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "weekend_id"
    t.boolean  "will_attend_meetings", default: true
    t.boolean  "living_lifestyle",     default: false
    t.boolean  "is_scheduled",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_weekend_team_apps_on_person_id", using: :btree
    t.index ["weekend_id"], name: "index_weekend_team_apps_on_weekend_id", using: :btree
  end

  create_table "weekends", force: :cascade do |t|
    t.string   "weekend_number",  limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.string   "location_name",   limit: 255
    t.string   "street",          limit: 255
    t.string   "city",            limit: 255
    t.integer  "state_id"
    t.string   "postal",          limit: 255
    t.integer  "coordinator_id"
    t.integer  "community_id"
    t.text     "theme"
    t.integer  "attendee_cost"
    t.integer  "angel_cost"
    t.string   "gender",          limit: 255
    t.text     "verse"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",                      default: false
    t.string   "step",            limit: 255, default: "open"
    t.string   "verse_reference", limit: 255
    t.index ["community_id"], name: "index_weekends_on_community_id", using: :btree
  end

end
