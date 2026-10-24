class AddUserToDomainResources < ActiveRecord::Migration[8.1]
  def change
    add_reference :groups, :user, null: false, foreign_key: true, type: :uuid
    add_reference :terrains, :user, null: false, foreign_key: true, type: :uuid
    add_reference :feeds, :user, null: false, foreign_key: true, type: :uuid
  end
end
