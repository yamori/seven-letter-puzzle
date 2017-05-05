class PuzzleSetController < ApplicationController

  def query
    @puzzleSet = PuzzleSet.find_or_create_by(puzzle_set_params)

    respond_to do |format|
      format.js
    end
  end

  private

    def puzzle_set_params
      params.require(:puzzle_set).permit(:center_letter, :other_letters)
    end
end
