# frozen_string_literal: true

require_relative './text_styles'
require_relative './intro'
require_relative './tiles'
require_relative './game'
require_relative './logic'
require_relative './computer'

# Board class
class Board
  include GameLogic

  attr_reader :role, :turns, :duplicates, :blanks, :codes, :turn
  attr_accessor :is_winner

  # When initializing a game, assigns the relevant variables
  def initialize(role, turns, duplicates, blanks)
    @role = role
    @turns = turns
    @duplicates = duplicates
    @blanks = blanks
    code_map

    # Setting the first turn
    @turn = 1

    # Setting an empty array for the future answers of the user
    @arr_answers = Array.new(@turn - 1)

    # Setting an empty array for the future grouping of the answers of the user
    @arr_ans_to_check = Array.new(@turn - 1)

    # Setting an empty array for the hints/feedback
    @hints_check = Array.new(@turn - 1)

    # Setting winner as false, as at the start there is no winner yet
    @is_winner = false

    # Until the current turn is bigger than the max amount of allowed turns, execute the code (the +1 is because the @turn variable started at 1)
    until @turn >= @turns + 1
      # Clear the CLI
      system('clear')

      # Print the tiles
      print_tiles

      # Set up a new board
      board(role)

      # If the array with the group of answers contains any 4 digit array that is equal to the secret code, declare a winner to be found, clear the CLI and print the final tiles layout with all the attempts and hints
      next unless @arr_ans_to_check.any?(@secret_code)

      @is_winner = true
      system('clear')
      print_tiles
    end

    # But if the current turn is over the max amount of turns and there is no winner, print the tiles as well but instead prompt for another round along an encouraging message
    return if @is_winner

    print_tiles
    # Printing out a loss message and the secret code colored tiles
    case role
    when '1'
      puts "You lost! The correct code was #{@@color_hash[@secret_code[0].to_s]} #{@@color_hash[@secret_code[1].to_s]} #{@@color_hash[@secret_code[2].to_s]} #{@@color_hash[@secret_code[3].to_s]}"
    when '2'
      puts "The computer couldn't guess your code! You beat it this time!"
    end
    puts 'Better luck next time!'
    restart
  end
end
