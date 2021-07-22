class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards, id: :uuid do |t|
      t.references :game, type: :uuid
      t.integer :cells, array: true, default: Array.new(25)
      t.timestamps
    end
  end
end
