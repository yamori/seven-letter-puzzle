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

class PuzzleSolution < ActiveRecord::Base

  # Validations
  validates :word, :score, :puzzle_set_id, presence: true
  validates :word, length: { minimum: 6 }

  # Associations
  belongs_to :puzzle_set
end
