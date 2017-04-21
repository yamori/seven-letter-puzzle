class PuzzleSetController < ApplicationController
  def query
    
    respond_to do |format|
      format.js
    end
  end
end
