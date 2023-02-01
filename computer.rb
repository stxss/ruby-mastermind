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
end

# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength
# rubocop: enable Layout/LineLength
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/PerceivedComplexity
