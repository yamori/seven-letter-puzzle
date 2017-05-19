class AddTotalScoreToPuzzleSets < ActiveRecord::Migration
  def change
    add_column :puzzle_sets, :total_score, :integer
  end
end
