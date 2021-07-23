class AddClaimedToCard < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :claimed, :bool, default: false
  end
end
