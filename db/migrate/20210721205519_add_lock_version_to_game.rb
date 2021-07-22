class AddLockVersionToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :lock_version, :integer, default: 0
  end
end
