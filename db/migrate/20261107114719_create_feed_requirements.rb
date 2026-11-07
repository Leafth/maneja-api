class CreateFeedRequirements < ActiveRecord::Migration[8.1]
  def change
    create_table :feed_requirements, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :feed, null: false, foreign_key: true, type: :uuid
      t.decimal :quantity_per_animal_kg, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :feed_requirements, %i[group_id feed_id], unique: true
  end
end
