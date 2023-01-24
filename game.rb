require './text_styles'
require './intro'
require './tiles'

class Game
    attr_reader :role, :turns, :duplicates, :blanks

    def initialize
        Intro.new
        loop do
            @role = ask_role
            break if (role == '1' || role == '2')
        end

        loop do
            @turns = ask_turns
            break if turns.between?(1, 12)
        end

        loop do
            puts "\nDo you want to allow for duplicates, (e.g 1122)? [Y/n]"
            @duplicates = duplicates?
            break if (duplicates == true || duplicates == false)
        end

        loop do
            puts "\nDo you want to allow for blanks, (e.g 0035)? [Y/n]"
            @blanks = blanks?
            break if (blanks == true || blanks == false)
        end
    end

    def ask_role
        puts "\nPress '1' to be the codemaker\nPress '2' to be the codebreaker"
        gets.chomp
    end

    def ask_turns
        puts "\nEnter the amount of turns that you want to play in the range 1-12: "
        gets.chomp.to_i
    end

    def duplicates?
        answer = gets.chomp
        case answer
        when 'Y'.downcase, 'YES'.downcase
            true
        when 'N'.downcase, 'NO'.downcase
            false
        else
            nil
        end
    end

    def blanks?
        answer = gets.chomp
        case answer
        when 'Y'.downcase, 'YES'.downcase
            true
        when 'N'.downcase, 'NO'.downcase
            false
        else
            nil
        end
    end
end


