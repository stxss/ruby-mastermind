# frozen_string_literal: true

require './text_styles'

class Intro
  using TextStyles

  def initialize
    print_info
  end

  def print_info
    puts 'Welcome to Mastermind!'.bold.italic.underlined
    puts "This is a game where you have to guess your opponent's secret code within a number of turns."

    puts 'The game is composed of two players:'
    puts "  - One player is known as The Code #{'MAKER'.bold}"
    puts "  - And the other is known as The Code #{'BREAKER'.bold}"

    puts "On each new turn, you'll get feedback about your guess"
  end
end

intro = Intro.new
