class CreateTransactions < ActiveRecord::Migration
  def change
    create_table "transactions", force: :cascade do |t|
      t.string   "symbol"
      t.decimal  "cost"
      t.string   "asset_type"
      t.decimal  "shares"
      t.decimal  "price"
      t.integer  "user_id"

      t.timestamps null: false
    end
  end
end
