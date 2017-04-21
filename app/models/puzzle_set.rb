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


  #  Rails.cache.read("dictionary_words").size

  def center_letter=(val)
    self[:center_letter] = val.upcase
  end

  def other_letters=(val)
    upperCase = val.upcase
    upperCaseAlphabetical = upperCase.chars.sort.join
    self[:other_letters] = upperCaseAlphabetical
  end

  def has_unique_letters
    # Can be assumed that :center_letter and :other_letters are upcase
    #  due to their setters above

    allLetters = self.center_letter.to_s + self.other_letters.to_s # to_s necessary in case nil
    originalCharCount = allLetters.size

    uniqCharCount = allLetters.split(//).uniq.size

    if uniqCharCount < originalCharCount
      errors.add(:other_letters, "all 7 letters must be unique")
    end
  end
end
