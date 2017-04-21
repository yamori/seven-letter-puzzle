class CreatePuzzleSets < ActiveRecord::Migration
  def change
    create_table :puzzle_sets do |t|
      t.string :center_letter
      t.string :other_letters

      t.timestamps null: false
    end
  end
end
