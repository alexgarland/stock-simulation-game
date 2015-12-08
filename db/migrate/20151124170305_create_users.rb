class CreateUsers < ActiveRecord::Migration
  def change
    create_table "users", force: :cascade do |t|
      t.string   "username"
      t.string   "email"
      t.string   "password_digest"
      t.decimal  "cash",            default: 500000.0
      t.decimal  "net_worth"
      t.decimal  "debt"

      t.timestamps null: false
    end
  end
end
