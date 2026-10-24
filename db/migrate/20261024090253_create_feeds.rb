class CreateFeeds < ActiveRecord::Migration[8.1]
  def change
    create_table :feeds, id: :uuid do |t|
      t.string :name, null: false
      t.decimal :stock_quantity, precision: 12, scale: 2, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :feeds, :deleted_at
  end
end
