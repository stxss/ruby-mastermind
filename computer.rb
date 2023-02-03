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
    attr_accessor :is_winner, :player_code

    def initialize(role, turns, duplicates, blanks)
        @turns = turns
        @duplicates = duplicates
        @blanks = blanks

        @player_code = []

        Board.new(role, turns, true, true)
    end
end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength
# rubocop: enable Layout/LineLength
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/PerceivedComplexity
