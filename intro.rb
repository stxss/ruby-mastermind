# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize

require_relative "./text_styles"
require_relative "./tiles"

# Class to print the introduction to the game
class Intro
  using TextStyles

  def initialize
    print_info
  end

  def print_info
    puts <<~HEREDOC
      #{"Welcome to Mastermind!".bold.italic.underlined}

      This is a game where you have to guess your opponent's secret code within a limited number of turns.

      First, the players choose how many turns will be played, which must be an even number.

      Then, the players choose/are assigned roles:
        - One player becomes the #{"CODEMAKER".bold.fg_color(:light_blue)}
        - And the other becomes the #{"CODEBREAKER".bold.fg_color(:yellow)}

      The #{"CODEMAKER".bold.fg_color(:light_blue)} has to choose a sequence of #{"four digits or colors".bold.underlined}. Here you'll use both, as each number will be associated with a color.

      The colors are #{" 1 or 'r' ".bold.bg_color(:red)} #{" 2 or 'g' ".bold.bg_color(:green)} #{" 3 or 'b' ".bold.bg_color(:blue)} #{" 4 or 'o' ".bold.bg_color(:orange)} #{" 5 or 'v' ".bold.bg_color(:violet)} and #{" 6 or 't' ".bold.bg_color(:teal)}. Blanks are marked as #{"  0  ".bold.bg_color(:gray)}

      The player can choose if they want to allow #{"duplicates and/or blanks".bold.underlined}.

      On each new turn, you'll get feedback about your guess.

      A #{"green".bold.fg_color(:dark_green)} keypeg means there was a correct #{"color and position".bold.fg_color(:dark_green)} guess, whereas a #{"pink".bold.fg_color(:pink)} keypeg means there is a peg with the #{"correct color".bold.fg_color(:dark_green)} but #{"wrong position".bold.fg_color(:dark_red)}\n

      The #{"order".bold.underlined} of the keypegs in the feedback section are irrelevant, meaning that the order of the keypegs #{"does not reflect".bold.underlined} the order of the guesses!

      Below is an example of a game with the following secret code:

      #{Tile.red} #{Tile.violet} #{Tile.orange} #{Tile.green}

      Here's how the pattern for cracking the code could look like:

      #{Tile.teal} #{Tile.red} #{Tile.blue} #{Tile.green}   ||   Feedback: #{Tile.place_color} #{Tile.color_only} #{Tile.empty_hint} #{Tile.empty_hint}

      #{Tile.violet} #{Tile.blue} #{Tile.blue} #{Tile.blank}   ||   Feedback: #{Tile.color_only} #{Tile.empty_hint} #{Tile.empty_hint} #{Tile.empty_hint}

      #{Tile.red} #{Tile.green} #{Tile.violet} #{Tile.blue}   ||   Feedback: #{Tile.place_color} #{Tile.color_only} #{Tile.color_only} #{Tile.empty_hint}

      #{Tile.red} #{Tile.violet} #{Tile.green} #{Tile.orange}   ||   Feedback: #{Tile.place_color} #{Tile.place_color} #{Tile.color_only} #{Tile.color_only}

      #{Tile.red} #{Tile.violet} #{Tile.orange} #{Tile.green}   ||   Feedback: #{Tile.place_color} #{Tile.place_color} #{Tile.place_color} #{Tile.place_color}
    HEREDOC
  end
end

# rubocop: enable Metrics/AbcSize
