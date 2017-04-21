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
end
