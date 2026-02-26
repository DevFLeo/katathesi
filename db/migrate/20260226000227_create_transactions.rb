class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :description
      t.decimal :value
      t.string :category
      t.integer :kind
      t.integer :frequency
      t.date :date
      t.decimal :profit_margin

      t.timestamps
    end
  end
end
