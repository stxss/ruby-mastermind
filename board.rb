# frozen_string_literal: true

require './text_styles'
require './intro'
require './tiles'
require './game'

# Board class
class Board
  attr_reader :role, :turns, :duplicates, :blanks, :codes, :turn
  attr_accessor :is_winner

  # When initializing a game, prints out the instructions in the Intro class, and prompts for questions regarding gameplay
  def initialize(role, turns, duplicates, blanks)
    @role = role
    @turns = turns
    @duplicates = duplicates
    @blanks = blanks
    code_map
    round(@turns)
  end

  def code_map
    # Available numbers to create codes from
    av = [1, 2, 3, 4, 5, 6]

    # Available numbers to create codes from if blanks are present
    av_blanks = [0, 1, 2, 3, 4, 5, 6]

    # Creating arrays for all the possible permutations
    if duplicates && blanks
      @codes = av_blanks.repeated_permutation(4).to_a
    elsif duplicates && !blanks
      @codes = av.repeated_permutation(4).to_a
    elsif !duplicates && blanks
      @codes = av_blanks.permutation(4).to_a
    elsif !duplicates && !blanks
      @codes = av.permutation(4).to_a
    end
  end

  def board
    tile_placeholder = "#{Tile.empty_tile}   "
    feedback_placeholder = "#{Tile.empty_hint} "

    system('clear')

    @turns.times do
      puts "#{"\n  #{tile_placeholder * 4}"}||  #{feedback_placeholder * 4}\n\n"
    end

    @turns.times do
      color_check
    end
  end

  def color_check
    @turns.times do
      puts 'Please, enter a color/number of your choice'
      answer = gets.chomp
    end
  end

  def round(turns)
    @turn = 1
    @max = turns * 4
    until @is_winner
      board
      p @max
      if @turn == @max && !@is_winner
        puts 'You lost! Better luck next time!'
        restart
      end
    end
  end

  # Function to use if the player chooses to be the codebreaker (aka computer makes the code)
  def codebreaker
    secret_code = @codes.sample
    p secret_code
  end

  # Method for restart
  def restart
    loop do
      puts "\nDo you want to play again? Please enter a valid option. [Y/N]"
      answer = gets.chomp
      case answer
      when 'Y', 'y', 'yes'.downcase
        Game.new
      when 'N', 'n', 'no'.downcase
        puts 'Thank you for playing Mastermind!'
        exit
      end
    end
  end
end
