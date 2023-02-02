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

class Computer
    include GameLogic
    attr_reader :turns, :duplicates, :blanks, :codes, :turn
    attr_accessor :is_winner

    def initialize(turns, duplicates, blanks)
        @turns = turns
        @duplicates = duplicates
        @blanks = blanks

        if duplicates && blanks
            @mode = 1
        elsif duplicates && !blanks
            @mode = 2
        elsif !duplicates && blanks
            @mode = 3
        elsif !duplicates && !blanks
            @mode = 4
        end

        @player_code = []

        get_code
    end

    def get_code
        @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
            't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]


        4.times do |i|
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
            puts "\nInsert the #{ordinal} digit/color of your secret code"
            loop do
              color = gets.chomp
              case @mode
              when 1
                break if @responses.include?(color)
              when 2
                break if @responses.include?(color) && (color != '0' && color != 'blank'.downcase)
              when 3
                break if @responses.include?(color) && (!@player_code.any?(color))
              when 4
                break if @responses.include?(color) && ((!@player_code.any?(color)) && (color != '0' && color != 'blank'.downcase))
              end
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
            print_code
          end
    end

    def print_code
      puts "Your code is #{@@color_hash[@player_code[0].to_s]} #{@@color_hash[@player_code[1]]} #{@@color_hash[@player_code[2]]} #{@@color_hash[@player_code[3]]}"
    end

end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength
# rubocop: enable Layout/LineLength
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/PerceivedComplexity
