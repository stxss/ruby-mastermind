# frozen_string_literal: true

require_relative "./text_styles"
require_relative "./intro"
require_relative "./tiles"
require_relative "./game"
require_relative "./logic"
require_relative "./computer"

# Board class
class Board
  include GameLogic

  attr_reader :role, :turns, :duplicates, :blanks, :codes, :turn
  attr_accessor :is_winner

  def initialize(role, turns, duplicates, blanks)
    @role = role
    @turns = turns
    @duplicates = duplicates
    @blanks = blanks
    code_map

    @turn = 1

    @arr_answers = Array.new(@turn - 1)
    @arr_ans_to_check = Array.new(@turn - 1)
    @hints_check = Array.new(@turn - 1)

    @is_winner = false

    until @turn >= @turns + 1
      system("clear")

      print_tiles

      board(role)

      next unless @arr_ans_to_check.any?(@secret_code)

      @is_winner = true
      system("clear")
      print_tiles
    end

    return if @is_winner

    print_tiles
    case role
    when "1"
      puts "You lost! The correct code was #{@@color_hash[@secret_code[0].to_s]} #{@@color_hash[@secret_code[1].to_s]} #{@@color_hash[@secret_code[2].to_s]} #{@@color_hash[@secret_code[3].to_s]}"
    when "2"
      puts "The computer couldn't guess your code! You beat it this time!"
    end
    puts "Better luck next time!"
    restart
  end
end
