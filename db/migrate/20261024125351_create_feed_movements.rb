class CreateFeedMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :feed_movements, id: :uuid do |t|
      t.references :feed, null: false, foreign_key: true, type: :uuid
      t.string :movement_type, null: false
      t.decimal :quantity, precision: 12, scale: 2, null: false
      t.decimal :value, precision: 12, scale: 2
      t.string :reason
      t.date :occurred_on, null: false

      t.timestamps
    end

    add_index :feed_movements, :movement_type
    add_index :feed_movements, :occurred_on
  end
end
