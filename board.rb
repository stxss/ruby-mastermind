# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/MethodLength

require_relative './text_styles'
require_relative './intro'
require_relative './tiles'
require_relative './game'


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
    @max = @turns * 4
    @board_row = [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile]
    @board_tiles = Array.new(@turns + 1, @board_row)
    @arr_answers = Array.new

    until @is_winner || (@turn > @max)
      if (@turn > @turns) && !@is_winner
        puts 'You lost! Better luck next time!'
        restart
      end
      board
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
    system('clear')
    # @turns.times do |i|
    #   puts "#{"\n  #{@board_tiles[i][0]}   #{@board_tiles[i][1]}   #{@board_tiles[i][2]}   #{@board_tiles[i][3]}"}   ||  #{Tile.empty_hint * 4}\n\n"
    # end

    for i in (0..@turns - 1)
      # puts "#{"\n  #{@board_tiles[i][0]}   #{@board_tiles[i][1]}   #{@board_tiles[i][2]}   #{@board_tiles[i][3]}"}   ||  #{Tile.empty_hint * 4}\n\n"
      puts "#{"\n  #{@arr_answers[i]}"}   ||  #{Tile.empty_hint * 4}\n\n"
    end

    p @secret_code

    color_check(@turn)

    @turn += 1
  end

  def color_check(first)
    @responses = ['0', '1', '2', '3', '4', '5', '6','blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                  't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

    p @arr_answers
    user_response = ''
    @answers = []

    4.times do |i|
      puts 'Please, enter a color/number of your choice'
      loop do
        user_response = gets.chomp
        break if @responses.include?(user_response)
      end
      @answers.push(user_response)

      @board_tiles[first][i] = @color_hash[user_response]

      @turns.times do |j|
        system('clear')
        p @turn
        p @answers
      end
    end
    @arr_answers.insert(first - 1, @answers)

    @arr_answers.each_with_index do |_inner, index_inner|
        puts "#{"\n #{@color_hash[@arr_answers[index_inner][0].to_s]} #{@color_hash[@arr_answers[index_inner][1].to_s]} #{@color_hash[@arr_answers[index_inner][2].to_s]} #{@color_hash[@arr_answers[index_inner][3].to_s]}"}   ||  #{Tile.empty_hint * 4}\n\n"
    end

    return unless (@turn > @turns) && !@is_winner

    puts 'You lost! Better luck next time!'
    restart
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
