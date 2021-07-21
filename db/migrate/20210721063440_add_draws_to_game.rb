class AddDrawsToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :draws, :integer, array: true, default: []
  end
end
