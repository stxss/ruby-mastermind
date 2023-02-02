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
require_relative './board'

class Computer < Board
    include GameLogic
    attr_reader :role, :turns, :duplicates, :blanks, :codes, :turn
    attr_accessor :is_winner

    def initialize(role, turns, duplicates, blanks)
        @turns = turns
        @duplicates = duplicates
        @blanks = blanks

        @player_code = []

        4.times do |i|
          get_code(i)
          print_code
        end
        puts "\nThe computer will begin breaking your code in a few moments!"
        sleep(3)
        system('clear')
        Board.new(role, turns, true, true)

    end

    def get_code(i)
        @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
            't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

        ordinal = ''
        case i
        when 0
            ordinal = 'first'
        when 1
            ordinal = 'second'
        when 2
            ordinal = 'third'
        when 3
            ordinal = 'fourth'
        end

        color = ''
        puts "\nInsert the #{ordinal} digit/color of your secret code: "
        loop do
          color = gets.chomp
          break if @responses.include?(color)
        end

        case color
        when 'blank'.downcase
          color = '0'
        when 'r'.downcase, 'red'.downcase
          color = '1'
        when 'g'.downcase, 'green'.downcase
          color = '2'
        when 'b'.downcase, 'blue'.downcase
          color = '3'
        when 'o'.downcase, 'orange'.downcase
          color = '4'
        when 'v'.downcase, 'violet'.downcase
          color = '5'
        when 't'.downcase, 'teal'.downcase
          color = '6'
        end

        @player_code.insert(i, color)
        print "\n\e[A\e[A\e[K"
    end

    def print_code
      puts "Your code is : #{@@color_hash[@player_code[0].to_s]} #{@@color_hash[@player_code[1]]} #{@@color_hash[@player_code[2]]} #{@@color_hash[@player_code[3]]}"
    end

end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength
# rubocop: enable Layout/LineLength
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/PerceivedComplexity
