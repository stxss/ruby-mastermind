# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/MethodLength
# rubocop: disable Layout/LineLength
# rubocop: disable Metrics/CyclomaticComplexity
# rubocop: disable Metrics/PerceivedComplexity

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
    @arr_answers = Array.new(@turn - 1, [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile])
    @arr_ans_to_check = Array.new(@turn - 1, [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile])

    until @is_winner || (@turn > @max)
      if (@turn > @turns) && !@is_winner
        puts 'You lost! Better luck next time!'
        restart
      end
      system('clear')
      print_tiles
      color_check
      board
    end
  end

  def code_map
    # The user can enter either a number,a letter representing a color or the color name
    # Hash for colored tiles for available options of player choice
    @color_hash = {
      '0' => Tile.blank,
      '1' => Tile.red, 'r': Tile.red, 'red': Tile.red,
      '2' => Tile.green, 'g': Tile.green, 'green': Tile.green,
      '3' => Tile.blue, 'b': Tile.blue, 'blue': Tile.blue,
      '4' => Tile.orange, 'o': Tile.orange, 'orange': Tile.orange,
      '5' => Tile.violet, 'v': Tile.violet, 'violet': Tile.violet,
      '6' => Tile.teal, 't': Tile.teal, 'teal': Tile.teal,
      "◯": "\u{25ef}"
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
    # @secret_code = @codes.sample
    # @secret_code = [5, 0, 1, 0]
    @secret_code = [5, 4, 3, 5]
  end

  def board
    @answers = [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile]
    @arr_answers.insert(@turn - 1, @answers)

    @ans_to_check = [77, 77, 77, 77]
    @arr_ans_to_check.insert(@turn - 1, @ans_to_check)

    4.times do |i|
      color_set(i)
    end

    @turn += 1
  end

  def color_set(idx)
    @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                  't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

    user_response = ''
    p @secret_code

    puts 'Please, enter a color/number of your choice'
    loop do
      user_response = gets.chomp
      break if @responses.include?(user_response)
    end

    @ans_to_check.insert(idx, user_response.to_i)
    @answers.insert(idx, @color_hash[user_response])

    system('clear')

    @answers.delete_at(-1)
    @ans_to_check.delete_at(-1)

    print_tiles

    return unless (@turn > @turns) && !@is_winner

    puts 'You lost! Better luck next time!'
    restart
  end

  def print_tiles
    @arr_answers.each do |(first, second, third, fourth)|
      puts "#{"\n #{first}  #{second}  #{third}  #{fourth}"}  ||  #{"#{Tile.empty_hint}  " * 4}\n\n"
    end
    puts "#{"\n #{Tile.empty_tile}  #{Tile.empty_tile}  #{Tile.empty_tile}  #{Tile.empty_tile}"}  ||  #{"#{Tile.empty_hint}  " * 4}\n\n" * (@turns - @arr_answers.length)
  end

  def color_check
    @arr_ans_to_check.each do |outer|
      # Check for number of colors
      @secret_tally = @secret_code.tally
      @user_tally = outer.tally
      @outcome = Hash.new { |h, k| h[k] = [] }

      # feedback_hash = Hash.new { |h, k| h[k] = [] }

      @correct_colors = 0
      @correct_index = 0

      # Check for the indexes
      p @secret_code.each_index.select { |i| @secret_code[i] == outer[i] }

      # new_arr = outer.select{ |a| @secret_code.include? a }
      new_arr = outer - (outer - @secret_code)

      p @secret_tally
      p @user_tally
      @secret_tally.each do |k1, v1|
        @user_tally.each do |k2, v2|
          if k1 == k2
            @outcome[k2] << [v1, v2].min
          end
        end
      end

      p @outcome


      @secret_code.each do |i|
        p @secret_code.count(i)
      end
      p new_arr

      # ary - (ary - other_ary)
      @correct_index += (@secret_code.each_index.select { |i| @secret_code[i] == outer[i] }).length

      # @correct_colors += (@secret_code & outer).length
      @correct_colors += (new_arr).length

      p @correct_index
      p @correct_colors
      4.times do |i|
      #   if @secret_code.any?(outer[i])
      #     # puts (outer.find_index(outer[i]))
      #     if @secret_code.each_index.select { |i| @secret_code[i] == outer[i] } == outer.each_index.select { |i| outer[i] == @secret_code[i] }

      #     end
      #   end
      #   # puts "for #{outer[i]} the count of pinks is #{feedback_hash.count('pink')} and the count of #{outer[i]} in secret is #{@secret_code.count(outer[i])}"
      end
      puts "correct colors is : #{@correct_colors} and correct indexes are : #{@correct_index}"
    end
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
# rubocop: enable Layout/LineLength
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/PerceivedComplexity
