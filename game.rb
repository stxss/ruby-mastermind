# frozen_string_literal: true

require './text_styles'
require './intro'
require './tiles'

# Game class
class Game
  attr_reader :role, :turns, :duplicates, :blanks, :codes, :turn
  attr_accessor :is_winner

  # When initializing a game, prints out the instructions in the Intro class, and prompts for questions regarding gameplay
  def initialize
    Intro.new

    loop do
      @role = ask_role
      break if role == '1' || role == '2'
    end

    loop do
      @turns = ask_turns
      break if turns.between?(1, 12)
    end

    loop do
      @duplicates = duplicates?
      break if duplicates == true || duplicates == false
    end

    loop do
      @blanks = blanks?
      break if blanks == true || blanks == false
    end

    @game = Board.new(role, turns, duplicates, blanks)
  end

  private

  # Asking what role does the player want to have
  def ask_role
    puts "\nPress '1' to be the codemaker\nPress '2' to be the codebreaker"
    gets.chomp
  end

  # Asking how many turns does the player want the game to be
  def ask_turns
    puts "\nEnter the amount of turns that you want to play in the range 1-12: "
    gets.chomp.to_i
  end

  # Asking if the player wants duplicate numbers
  def duplicates?
    puts "\nDo you want to allow for duplicates, (e.g 1122)? [Y/n]"
    answer = gets.chomp
    case answer
    when 'Y'.downcase, 'YES'.downcase
      true
    when 'N'.downcase, 'NO'.downcase
      false
    end
  end

  # Asking if the player wants to play with blanks
  def blanks?
    puts "\nDo you want to allow for blanks, (e.g 0035)? [Y/n]"
    answer = gets.chomp
    case answer
    when 'Y'.downcase, 'YES'.downcase
      true
    when 'N'.downcase, 'NO'.downcase
      false
    end
  end
end
