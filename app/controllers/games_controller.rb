require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Initialize the grid variable
    generated_grid = []
    # Generate the grid size
    grid_size = rand(4..12)
    # Generate the alphabet
    grid = Array("a".."z")
    # Populate the grid with letters
    grid_size.times { |i| generated_grid[i] = grid.sample(1)[0]}
    # Return the populated grid Array
    @letters = generated_grid
    return @letters
  end

  def score
    # raise
    @letters = params[:letters].split
    @answer = params[:answer]
    @valid_word = valid_word?(@answer)
    @included = included?(@answer, @letters)
    @message = message(@included, @letters, @answer, @valid_word)
  end

  private

  # Check if the word exists in english
  def valid_word?(attempt)
    filepath = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response = open(filepath).read
    word_hash = JSON.parse(response)
    return word_hash["found"]
  end

  def included?(answer, letters)
    answer.chars.all? { |letter|
      answer.count(letter) <= letters.count(letter)
    }
  end

  def message(included, letters, answer, valid_word)
    if !included
      grid_chars = ""
      letters.each do |letter|
        grid_chars += letter.upcase + ", "
      end
      grid_chars.chomp(",")
      @message = "Sorry but #{answer} can't be built out of #{grid_chars}"
    elsif !valid_word
      @message ="Sorry but #{answer} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{answer.upcase} is a valid English word!"
    end
  end

end
