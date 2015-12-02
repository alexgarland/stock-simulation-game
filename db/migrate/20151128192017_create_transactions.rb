class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :symbol
      t.string :cost
      t.string :time
      t.string :shares
      t.string :price

      t.timestamps null: false
    end
  end
end
