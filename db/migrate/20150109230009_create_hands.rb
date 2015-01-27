class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.references :player, index: true
      t.integer :round, default: 1
      t.string :dice
      t.integer :lose, default: 0

      t.timestamps
    end
  end
end
