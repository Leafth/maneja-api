class CreateOccupations < ActiveRecord::Migration[8.1]
  def change
    create_table :occupations, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :terrain, null: false, foreign_key: true, type: :uuid
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end

    add_index :occupations, :group_id, unique: true, where: "ended_at IS NULL", name: "index_occupations_on_active_group"
    add_index :occupations, :terrain_id, unique: true, where: "ended_at IS NULL", name: "index_occupations_on_active_terrain"
  end
end
