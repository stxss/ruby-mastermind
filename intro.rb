# frozen_string_literal: true

require './text_styles'
require './tiles.rb'

class Intro
  using TextStyles

  def initialize
    print_info
  end

  def print_info
    puts 'Welcome to Mastermind!'.bold.italic.underlined

    puts "\nThis is a game where you have to guess your opponent's secret code within a limited number of turns."
    puts "\nFirst, the players choose how many turns will be played, which must be an even number."

    puts "\nThen, the players choose/are assigned roles:"
    puts "  - One player becomes the #{'CODEMAKER'.bold.fg_color(:light_blue)}"
    puts "  - And the other becomes the #{'CODEBREAKER'.bold.fg_color(:yellow)}"

    puts "\nThe #{'CODEMAKER'.bold.fg_color(:light_blue)} has to choose a sequence of #{'four digits or colors'.bold.underlined}. Here you'll use both, as each number will be associated with a color."

    puts "\nThe colors are #{' 1 or \'r\' '.bold.bg_color(:red)} #{' 2 or \'g\' '.bold.bg_color(:green)} #{' 3 or \'b\' '.bold.bg_color(:blue)} #{' 4 or \'o\' '.bold.bg_color(:orange)} #{' 5 or \'v\' '.bold.bg_color(:violet)} and #{' 6 or \'t\' '.bold.bg_color(:teal)}. Blanks are marked as #{'  0  '.bold.bg_color(:gray)}"

    puts "\nThe player can choose if they want to allow #{'duplicates and/or blanks'.bold.underlined}."

    puts "\nOn each new turn, you'll get feedback about your guess."

    puts "\nA #{'green'.bold.fg_color(:dark_green)} keypeg means there was a correct #{'color and position'.bold.fg_color(:dark_green)} guess, whereas a #{'pink'.bold.fg_color(:pink)} keypeg means there is a peg with the #{'correct color'.bold.fg_color(:dark_green)} but #{'wrong position'.bold.fg_color(:dark_red)}\n"
    puts "\nThe #{'order'.bold.underlined} of the keypegs in the feedback section are irrelevant, meaning that the order of the keypegs #{'does not reflect'.bold.underlined} the order of the guesses!"

    puts "\nBelow is an example of a game with the following secret code:"

    puts "\n#{Tile.red} #{Tile.violet} #{Tile.orange} #{Tile.green}"

    puts "\nHere's how the pattern for cracking the code could look like:"

    puts "\n#{Tile.teal} #{Tile.red} #{Tile.blue} #{Tile.green}" + "   ||   " + "Feedback: #{Tile.color_only} #{Tile.place_color} #{Tile.empty} #{Tile.empty}"
    puts "\n#{Tile.violet} #{Tile.blue} #{Tile.blue} #{Tile.blank}" + "   ||   " + "Feedback: #{Tile.color_only} #{Tile.empty} #{Tile.empty} #{Tile.empty}"
    puts "\n#{Tile.red} #{Tile.green} #{Tile.violet} #{Tile.blue}" + "   ||   " + "Feedback: #{Tile.place_color} #{Tile.place_color} #{Tile.color_only} #{Tile.empty}"
    puts "\n#{Tile.red} #{Tile.violet} #{Tile.green} #{Tile.orange}" + "   ||   " + "Feedback: #{Tile.place_color} #{Tile.place_color} #{Tile.color_only} #{Tile.color_only}"

    puts "\n#{Tile.red} #{Tile.violet} #{Tile.orange} #{Tile.green}"+ "   ||   " + "Feedback: #{Tile.place_color} #{Tile.place_color} #{Tile.place_color} #{Tile.place_color}"
    puts "\nCongratulations! You broke the code!!\n\n"

  end
end

intro = Intro.new

