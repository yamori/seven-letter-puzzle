class WelcomeController < ApplicationController
  def index
    @puzzleSet = PuzzleSet.new
  end
end
