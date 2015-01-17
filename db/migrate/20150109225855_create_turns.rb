class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.references :player, index: true
      t.integer :round, default: 1
      t.integer :face
      t.integer :quantity
      t.string  :guess_type
      t.integer :past_turn_id

      t.timestamps
    end
  end
end
