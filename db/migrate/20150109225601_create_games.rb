class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :last_turn_id, default: 1
      t.integer :round, default: 1
      t.boolean :flowing_right, default: true

      t.timestamps
    end
  end
end
