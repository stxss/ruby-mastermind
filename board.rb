# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/MethodLength

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

    @turn = 1
    @max = turns * 4
    until @is_winner
      board

      if @turn > @max && !@is_winner
        puts 'You lost! Better luck next time!'
        restart
      end
    end
  end

  def code_map
    # The user can enter either a number,a letter representing a color or the color name
    # Hash for colored tiles for available options of player choice
    @color_hash = {
      '1' => Tile.red, r: Tile.red, red: Tile.red,
      '2' => Tile.green, g: Tile.green, green: Tile.green,
      '3' => Tile.blue, b: Tile.blue, blue: Tile.blue,
      '4' => Tile.orange, o: Tile.orange, orange: Tile.orange,
      '5' => Tile.violet, v: Tile.violet, violet: Tile.violet,
      '6' => Tile.teal, t: Tile.teal, teal: Tile.teal
    }

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
    @secret_code = @codes.sample
  end

  def board
    tile_placeholder = "#{Tile.empty_tile}   "
    feedback_placeholder = "#{Tile.empty_hint} "

    system('clear')

    @turns.times do
      puts "#{"\n  #{tile_placeholder * 4}"}||  #{feedback_placeholder * 4}\n\n"
    end

    p @secret_code

    @turns.times do
      color_check
    end

    @turn += 1
  end

  def color_check
    @responses = ['1', '2', '3', '4', '5', '6', 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                  't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]
    answer = ''
    puts 'Please, enter a color/number of your choice'
    loop do
      answer = gets.chomp
      break if @responses.include?(answer)
    end
    new_board(answer)
  end

  def new_board(answer)
    system('clear')
    @board_tiles = [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile]
    guess1 = @board_tiles[0]
    guess2 = @board_tiles[1]
    guess3 = @board_tiles[2]
    guess4 = @board_tiles[3]
    case (@turn % 4)
    when 1
      guess1 = @color_hash[answer]
    when 2
      guess2 = @color_hash[answer]
    when 3
      guess3 = @color_hash[answer]
    when 0
      guess4 = @color_hash[answer]
    end
    # tile_color = @color_hash[answer]
    # puts tile_color
    puts "#{"\n  #{guess1} #{guess2} #{guess3} #{guess4}"}||  #{Tile.empty_hint * 4}\n\n"
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

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength
