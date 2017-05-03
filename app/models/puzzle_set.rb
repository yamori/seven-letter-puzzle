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

class PuzzleSet < ActiveRecord::Base
  
  validates :center_letter, :other_letters, presence: true
  validates :center_letter, length: { is: 1 }
  validates :other_letters, length: { is: 6 }
  validate :has_unique_letters

  # Associations
  has_many :puzzle_solutions, dependent: :destroy

  # Callbacks
  after_save :query_dictionary_and_persist_solutions
  #after_create :query_dictionary_and_persist_solutions

  def center_letter=(val)
    # Make uppercase
    self[:center_letter] = val.upcase
  end

  def other_letters=(val)
    # Make uppercase and alphabetize
    upperCase = val.upcase
    upperCaseAlphabetical = upperCase.chars.sort.join
    self[:other_letters] = upperCaseAlphabetical
  end

  def self.find_or_create_by(center_letter, other_letters)
    # Overriding this method to work with the alphabetization of other_letters
    pSet = PuzzleSet.new(center_letter: center_letter, other_letters: other_letters)
    existing_pSet = PuzzleSet.where(center_letter: pSet.center_letter, other_letters: pSet.other_letters)

    # The important bit
    if existing_pSet.size>0
      return existing_pSet.first
    else
      pSet.save
      return pSet
    end
  end

  private

  def query_dictionary_and_persist_solutions
    # Inspects the word dictionary (in cache) using self's letters
    solutions = []
    
    Rails.cache.read("dictionary_words").each do |candidateWord|

      # Scheme is to eliminate valid chars, and what's left is incorrect
      extraneousChars = candidateWord
      (self.center_letter + self.other_letters).split(//).each do |char|
        extraneousChars = extraneousChars.gsub(char,'')
      end
      # If there are any chars leftover, it's not valid
      next if extraneousChars.size > 0

      # At this point we know candidateWord has only desired letters
      
      # Check score
      usesAllChars = true # assume true
      (self.center_letter + self.other_letters).split(//).each do |char|
        usesAllChars = usesAllChars & candidateWord.include?(char)
      end
      score = usesAllChars ? 3 : 1

      # Attach solution
      solutions.push( [candidateWord, score] )
    end
    
    # Sort the solutions: first by score, the word length, then alphabetize the words
    solutions = solutions.sort{|a,b| (a[1] <=> b[1]) == 0 ? (b[0].length == a[0].length ? (a[0] <=> b[0]) : (b[0].length <=> a[0].length)) : (b[1] <=> a[1]) }

    # Persist each solution
    solutions.each do |solution|
      self.puzzle_solutions.create(word: solution[0], score: solution[1])
    end

    return solutions
  end

  # Validation support
  def has_unique_letters
    # Can be assumed that :center_letter and :other_letters are upcase
    #  due to their setters above

    allLetters = self.center_letter.to_s + self.other_letters.to_s # to_s necessary in case nil
    originalCharCount = allLetters.size

    uniqCharCount = allLetters.split(//).uniq.size

    if uniqCharCount < originalCharCount
      errors.add(:other_letters, "all 7 letters must be unique")
      errors.add(:center_letter, "all 7 letters must be unique")
    end
  end
end
