class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false
      t.integer :animal_count, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :groups, :deleted_at
  end
end
