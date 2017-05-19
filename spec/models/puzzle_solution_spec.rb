# == Schema Information
#
# Table name: puzzle_solutions
#
#  id            :integer          not null, primary key
#  puzzle_set_id :integer
#  word          :string
#  score         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe PuzzleSolution, type: :model do

  scenario "must have word" do
    sol = PuzzleSolution.new(puzzle_set_id: 1, score: 1)
    expect( sol.valid?).to eq false
  end

  scenario "must have score" do
    sol = PuzzleSolution.new(word: "x", puzzle_set_id: 1)
    expect( sol.valid?).to eq false
  end

  scenario "must have puzzle_set_id" do
    sol = PuzzleSolution.new(word: "x", score: 1)
    expect( sol.valid?).to eq false
  end

  scenario "words must be at least 6 chars" do
    sol = PuzzleSolution.new(word: "xxxxx", puzzle_set_id: 1, score: 1)
    expect( sol.valid?).to eq false
  end

  # Associations
  
  scenario "belongs to puzzle_set" do
    # This letter combination doesn't hit on anything in the dev word bank
    pSet = PuzzleSet.find_or_create_by(center_letter: "A", other_letters: "BCDEFG")
    sol = PuzzleSolution.create(puzzle_set_id: pSet.id, score: 1, word: "ABCDEFG")
    expect( pSet.puzzle_solutions.size).to eq 1
  end

  scenario "destroy dependent puzzle_set" do
    # This letter combination doesn't hit on anything in the dev word bank
    pSet = PuzzleSet.find_or_create_by(center_letter: "A", other_letters: "BCDEFG")
    sol = PuzzleSolution.create(puzzle_set_id: pSet.id, score: 1, word: "ABCDEFG")
    pSet.destroy
    expect( PuzzleSolution.all.size ).to eq 0
  end

end
