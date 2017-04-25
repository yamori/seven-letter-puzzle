class CreatePuzzleSolutions < ActiveRecord::Migration
  def change
    create_table :puzzle_solutions do |t|
      t.integer :puzzle_set_id
      t.string :word
      t.integer :score

      t.timestamps null: false
    end
  end
end
