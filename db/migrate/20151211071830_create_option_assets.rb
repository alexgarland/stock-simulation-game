class CreateOptionAssets < ActiveRecord::Migration
  def change
    create_table :option_assets do |t|
      t.string   "symbol"
      t.string   "asset_type"
      t.decimal  "number"
      t.decimal  "spot_price"
      t.decimal  "value"
      t.integer  "user_id"

      t.timestamps null: false
    end
  end
end
