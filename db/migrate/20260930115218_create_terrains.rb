class CreateTerrains < ActiveRecord::Migration[8.1]
  def change
    create_table :terrains, id: :uuid do |t|
      t.string :name, null: false
      t.integer :rest_days, null: false
      t.string :status, null: false, default: "available"
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :terrains, :status
    add_index :terrains, :deleted_at
  end
end
