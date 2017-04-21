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

require 'test_helper'

class PuzzleSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
