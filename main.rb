# frozen_string_literal: true

require './text_styles'
require './intro'
require './tiles'
require './game'
require './board'

Game.new

# TODO- CL game ; 12 turns to guess secret code; starts with guessing computer's random code
# * Game randomly selects a code (colors) and human must guess

# TODO- Have to give proper feedback on the guesses
# TODO - Refactor the code to allow the human player to choose whether they want to create or guess the code
# TODO - Build it out so the computer has to guess, in the case of the human player being the code creator

# TODO- Prompt for allowing duplicates/blanks
# Todo- this means 4 different sets of numbers
