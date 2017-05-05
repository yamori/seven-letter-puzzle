# == Schema Information
#
# Table name: puzzle_sets
#
#  id            :integer          not null, primary key
#  center_letter :string
#  other_letters :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe PuzzleSet, type: :model do

  scenario "letters must exist" do
    pSet = PuzzleSet.new
    expect( pSet ).not_to be_valid

    pSet.center_letter = ""
    pSet.other_letters = ""
    expect( pSet ).not_to be_valid
  end

  scenario "correct length of center_letter" do
    pSet = PuzzleSet.new
    pSet.other_letters = "abcdef" # This is correct
    
    pSet.center_letter = "xx"
    expect( pSet ).not_to be_valid

    pSet.center_letter = ""
    expect( pSet ).not_to be_valid
  end

  scenario "correct length of other_letters" do
    pSet = PuzzleSet.new
    pSet.center_letter = "x" # This is correct

    pSet.other_letters = "abcdefg" 
    expect( pSet ).not_to be_valid

    pSet.other_letters = "abcde"
    expect( pSet ).not_to be_valid
  end

  scenario "center_letter auto sets to upcase" do
    pSet = PuzzleSet.new

    testChar = "x"
    pSet.center_letter = testChar
    expect( pSet.center_letter ).to eq testChar.upcase
  end

  scenario "other_letters auto sets to upcase" do
    pSet = PuzzleSet.new
    
    testChars = "aBxZ"
    pSet.other_letters = testChars
    expect( pSet.other_letters ).to eq testChars.upcase
  end

  scenario "other_letters auto sets to alphabetical order" do
    pSet = PuzzleSet.new

    nonAlphabetical = "fedcab"
    isAlphabetical = nonAlphabetical.upcase.chars.sort.join 
    pSet.other_letters = nonAlphabetical
    expect( pSet.other_letters ).to eq isAlphabetical
  end

  scenario "all letters must be unique" do
    pSet = PuzzleSet.new

    pSet.center_letter = "a"
    pSet.other_letters = "abcdef" 
    expect( pSet ).not_to be_valid

    pSet.center_letter = "z"
    pSet.other_letters = "abcdee" 
    expect( pSet ).not_to be_valid

    pSet.center_letter = "z"
    pSet.other_letters = "abcdef" 
    expect( pSet ).to be_valid
  end

  scenario "when persisting, can successfuly solve the puzzle" do
    # This uses the words_dev.txt word dictionary, loaded into
    #  cache for non-production environments
    
    pSet = PuzzleSet.new
    pSet.center_letter = "p"
    pSet.other_letters = "uarity"
    pSet.save 

    solutions = pSet.puzzle_solutions

    correct_sol_arr = [["pituitary".upcase,3],["parity".upcase,1],["purity".upcase,1]]

    solutions.each_with_index do |solution,indx|
      expect(solution.word).to eq correct_sol_arr[indx][0]
      expect(solution.score).to eq correct_sol_arr[indx][1]
    end

  end

  # Solutions: persistence and query re: callbacks

  scenario "new and valid puzzle_set creates new puzzle_solution records" do
    # (verify)
    expect(PuzzleSolution.all.size).to eq 0

    # This assumes the words_dev.txt dictionary is loaded
    params = Hash["center_letter" => 'f', "other_letters" => 'luvent']
    pSet = PuzzleSet.find_or_create_by(params)
    expect(pSet.puzzle_solutions.size).not_to eq 0
    expect(PuzzleSolution.all.size).not_to eq 0
  end

  scenario "existing (and valid) puzzle_set does not create any new puzzle_solution records" do
    # Persist some data
    params = Hash["center_letter" => 'f', "other_letters" => 'luvent']
    pSet = PuzzleSet.find_or_create_by(params)
    expect(PuzzleSet.all.size).to eq 1
    numberSolutions = PuzzleSolution.all.size
    expect(numberSolutions).not_to eq 0

    # Try to submit again. (letters shuffled intentionally)
    params2 = Hash["center_letter" => params['center_letter'], "other_letters" => 'ulvent']
    pSet_prime = PuzzleSet.find_or_create_by(params2)
    expect(PuzzleSet.all.size).to eq 1
    expect(PuzzleSolution.all.size).to eq numberSolutions
    expect(pSet_prime.puzzle_solutions.size).to eq numberSolutions
  end

  scenario "new but invalid puzzle_set does not create any new puzzle_solution records" do
    # (verify)
    expect(PuzzleSet.all.size).to eq 0
    expect(PuzzleSolution.all.size).to eq 0

    # Attempt to create invalid pSet
    params = Hash["center_letter" => 'f', "other_letters" => 'luv']
    pSet = PuzzleSet.find_or_create_by(params)
    expect(PuzzleSolution.all.size).to eq 0
    expect(PuzzleSet.all.size).to eq 0
  end
end
