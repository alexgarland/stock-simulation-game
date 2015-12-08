class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table "portfolios", force: :cascade do |t|
      t.string   "symbol"
      t.string   "asset_type"
      t.decimal  "number"
      t.decimal  "price"
      t.decimal  "value"
      t.integer  "user_id"

      t.timestamps null: false
    end
  end
end
