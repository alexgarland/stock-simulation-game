class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :symbol
      t.string :type
      t.decimal :number
      t.decimal :price
      t.decimal :value

      t.timestamps null: false
    end
  end
end
