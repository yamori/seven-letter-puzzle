class PuzzleSetController < ApplicationController

  def query

    pSet = PuzzleSet.new(puzzle_set_params)

    if pSet.valid?
      @solutions = pSet.query_dictionary
    else
      @solutions = []
    end

    respond_to do |format|
      format.js
    end
  end

  private

    def puzzle_set_params
      params.require(:puzzle_set).permit(:center_letter, :other_letters)
    end
end
