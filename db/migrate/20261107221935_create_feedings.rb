class CreateFeedings < ActiveRecord::Migration[8.1]
  def change
    create_table :feedings, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :feed, null: false, foreign_key: true, type: :uuid
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.datetime :occurred_at, null: false

      t.timestamps
    end
  end
end
