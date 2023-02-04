# frozen_string_literal: true

# Module that handles the logic of the game
module GameLogic
  # The user can enter either a number,a letter representing a color or the color name
  # Hash for colored tiles for available options of player choice
  @@color_hash = {
    '0' => Tile.blank,
    '1' => Tile.red, 'r': Tile.red, 'red': Tile.red,
    '2' => Tile.green, 'g': Tile.green, 'green': Tile.green,
    '3' => Tile.blue, 'b': Tile.blue, 'blue': Tile.blue,
    '4' => Tile.orange, 'o': Tile.orange, 'orange': Tile.orange,
    '5' => Tile.violet, 'v': Tile.violet, 'violet': Tile.violet,
    '6' => Tile.teal, 't': Tile.teal, 'teal': Tile.teal,
    "◯": "\u{25ef}"
  }

  # Method to define the codes maps
  def code_map
    # Hint/Feedback hash, Green if the user has guesses the color and place correctly, Pink if the user has only guessed the color and empty if the user hasn't guessed the place nor the color
    @hint_hash = {
      'green' => Tile.place_color,
      'pink' => Tile.color_only,
      'empty' => Tile.empty_hint
    }

    # Available numbers to create codes from if blanks are not present
    av = [1, 2, 3, 4, 5, 6]

    # Available numbers to create codes from if blanks are present
    av_blanks = [0, 1, 2, 3, 4, 5, 6]

    # Creating arrays for all the possible permutations
    if duplicates && blanks
      @codes = av_blanks.repeated_permutation(4).to_a
    elsif duplicates && !blanks
      @codes = av.repeated_permutation(4).to_a
    elsif !duplicates && blanks
      @codes = av_blanks.permutation(4).to_a
    elsif !duplicates && !blanks
      @codes = av.permutation(4).to_a
    end

    # Possible responses
    @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                  't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

    @responses_no_blanks = ['1', '2', '3', '4', '5', '6', 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                            't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

    @secret_code = []
    @player_code = []

    # If the user is a code breaker
    # From the @codes variable, depending on the user preferences, take a random 4 digit code and make it the secret code
    case role
    when '1'
      @secret_code = @codes.sample
    when '2'
      # If the user is the codemaker, get the code manually and set it as the secret code
      4.times do |i|
        get_code(i)
        print_code
      end
      @secret_code = @player_code
      puts "\nThe computer will begin breaking your code in a few moments!"
      sleep(3)
    end
  end

  # Method for setting up the board
  def board(role)
    # Create an empty 4 space array to store empty tiles that act as placeholders and inserting it into the group array
    @answers = [Tile.empty_tile, Tile.empty_tile, Tile.empty_tile, Tile.empty_tile]
    @arr_answers.insert(@turn - 1, @answers)

    # Create an empty 4 space array to store the user's digit inputs and inserting it into the group array
    @ans_to_check = [nil, nil, nil, nil]
    @arr_ans_to_check.insert(@turn - 1, @ans_to_check)

    # Create an empty 4 space array to store empty hints/feedback and inserting it into the group array
    @hints_to_insert = [Tile.empty_hint, Tile.empty_hint, Tile.empty_hint, Tile.empty_hint]
    @hints_check.insert(@turn - 1, @hints_to_insert)

    # As a code is a 4 digit number, set a color 4 times, each individually
    # In the case of the player choosing to be the codebreaker, proceed with the first condition of setting colors manually
    case role
    when '1'
      4.times do |i|
        color_set(i)
      end
    when '2'
      # In the case of the player choosing to be the codemaker, proceed with the condition where the computer follows an algorithm to try and break the code
      @new_codes = @codes
      if @turn == 1
        @rand_guess = [0, 0, 1, 1]
      elsif @turn > 1
        # Choose if the next guess is the first element of the rest of the codes or a random guess
        options = %i[sample first_element]
        selected = options.sample
        @rand_guess = if selected == :sample
                        @new_codes.sample
                      else
                        @new_codes[0]
                      end
      end

      # Same as with the user, set 4 colors
      4.times do |i|
        color_set_computer(i)
      end

      # Delete the guess, as if it is not the winning option, it is not needed
      @new_codes.delete_at(@new_codes.find_index(@rand_guess))
    end

    # Check the colors
    color_check

    filter_codes(@correct_index, @correct_colors) if role == '2'

    # Advance to the next turn
    @turn += 1
  end

  # In case the answer is not a number but a letter or color, correspond it to the number
  def color_naming_swap(response)
    case response
    when 'blank'.downcase, '0'
      '0'
    when 'r'.downcase, 'red'.downcase, '1'
      '1'
    when 'g'.downcase, 'green'.downcase, '2'
      '2'
    when 'b'.downcase, 'blue'.downcase, '3'
      '3'
    when 'o'.downcase, 'orange'.downcase, '4'
      '4'
    when 'v'.downcase, 'violet'.downcase, '5'
      '5'
    when 't'.downcase, 'teal'.downcase, '6'
      '6'
    end
  end

  # Get the code when the user is the codemaker
  def get_code(i)
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
    puts "\nThe available colors to insert are #{Tile.blank} #{Tile.red} #{Tile.green} #{Tile.blue} #{Tile.orange} #{Tile.violet} #{Tile.teal}"
    puts "Insert the #{ordinal} digit/color of your secret code: "
    loop do
      color = gets.chomp.downcase
      break if @responses.include?(color)
    end

    @player_code.insert(i, color_naming_swap(color).to_i)
    print "\n\e[A\e[A\e[K"
  end

  def print_code
    puts "Your code is : #{@@color_hash[@player_code[0].to_s]} #{@@color_hash[@player_code[1].to_s]} #{@@color_hash[@player_code[2].to_s]} #{@@color_hash[@player_code[3].to_s]}"
  end

  # Method to insert the answers into the respective arrays
  def arr_insertion(idx, response)
    # Insert the answer as a code to the checking array to compare it with the secret code
    @ans_to_check.insert(idx, response)

    # Inserting the answer as a color tile to display it to the user
    @answers.insert(idx, @@color_hash[response.to_s])

    # Clear the CLI
    system('clear')

    # Delete the last item from the arrays above, as the method inserts answers at the start and doesn't overwrite anything, so to prevent having 8-length arrays, for each response input, the last element is deleted. This way it is possible to have only arrays with 4 items
    @answers.delete_at(-1)
    @ans_to_check.delete_at(-1)
  end

  # Method for manual setting of colors
  def color_set(idx)
    # Initiating the user response as an empty string
    user_response = ''

    # Asking the user until they give a valid response
    if blanks
      puts "\nThe available colors to insert are #{Tile.blank} #{Tile.red} #{Tile.green} #{Tile.blue} #{Tile.orange} #{Tile.violet} #{Tile.teal}"
    else
      puts "\nThe available colors to insert are #{Tile.red} #{Tile.green} #{Tile.blue} #{Tile.orange} #{Tile.violet} #{Tile.teal}"
    end
    puts 'Please, enter a color/number of your choice'
    loop do
      user_response = gets.chomp.downcase
      if blanks
        break if @responses.include?(user_response)
      elsif @responses_no_blanks.include?(user_response)
        break
      end
    end

    # Convert the user response to the respective colors (handling cases where the user can either input a number, a lowercase/uppercase letter/color name)
    arr_insertion(idx, color_naming_swap(user_response).to_i)

    # Print out the board
    print_tiles
  end

  # Method for computational setting of the colors
  def color_set_computer(idx)
    # Possible responses
    @responses = %w[0 1 2 3 4 5 6]

    # Initiating the computer response as an empty string
    computer_response = ''

    # Asking the computer until they give a valid response
    loop do
      computer_response = computer_guess(@turn - 1, idx)
      break if @responses.include?(computer_response)
    end

    # Convert the user response to the respective colors (handling cases where the user can either input a number, a lowercase/uppercase letter/color name)
    arr_insertion(idx, computer_response.to_i)

    # Print out the board
    print_tiles
  end

  def computer_guess(_order, idx)
    guess = ''
    puts "The computer is working and it says that there are #{@new_codes.length} possible codes left! :)"

    # For each index output the individual number
    case idx
    when 0
      guess = @rand_guess[0].to_s
    when 1
      guess = @rand_guess[1].to_s
    when 2
      guess = @rand_guess[2].to_s
    when 3
      guess = @rand_guess[3].to_s
    end
    sleep(1)
    guess
  end

  # Filtering remaining possibilities using own implementation of swaszek algorithm
  def filter_codes(green, pink)
    # Total colors that are discovered
    total_cols = green + pink
    # If there are no color coincidences on the first try, delete all of the codes that have the numbers from the first try, as having 0 green/pink feedback means that not a single color of those was right. So if the first try is 0011 and the secret code is 3445, it means we can safely remove all the codes that contain either a 0 or a 1
    if total_cols.zero?
      @new_codes.delete_if { |code| !(@rand_guess & code).empty? }
    elsif !green.zero? && pink.zero?
      # If there are green hints and no pink hints, delete all of the codes where the amount of green hints would be less than the green pegs from this last guess
      @new_codes.delete_if { |code| (@secret_code.each_index.select { |i| @secret_code[i] == code[i] }).length < green }
    elsif !green.zero? && !pink.zero?
      # If there are green and pink hints, delete all of the codes where the amount of the green and pink hints would be less than the sum of pink and green hints of this last guess and where, at the same time, the amount of green hints would be less than the amount of pink hints (´|i| @secret_code[i] == code[i]´ this part checks if the index is the same)
      @new_codes.delete_if do |code|
        (@secret_code.each_index.select do |i|
           @secret_code[i] == code[i]
         end).length != total_cols && (@secret_code.each_index.select do |i|
                                         @secret_code[i] == code[i]
                                       end).length < pink
      end
    end
  end

  # Method for color checking
  def color_check
    # Iterate over each item of the group of answers array
    @arr_ans_to_check.each do |user_code|
      # Tally both the secret code and user code to count how many of each color there are
      # This is made to have in mind that if there are duplicate colors in the guess, they cannot all be awarded a key peg unless they correspond to the same number of duplicate colors in the hidden code.
      # For example, if the hidden code is red-red-blue-blue and the player guesses red-red-red-blue, the codemaker will award two colored key pegs for the two correct reds, nothing for the third red as there is not a third red in the code, and a colored key peg for the blue. No indication is given of the fact that the code also includes a second blue.
      @secret_tally = @secret_code.tally
      @user_tally = user_code.tally
      @outcome = Hash.new { |h, k| h[k] = [] }

      # Clearing this array to not duplicate feedbacks (aka to not have arrays like [['empty', 'empty', 'empty', 'empty'], ['green', 'pink', 'empty', 'empty', 'empty', 'empty','empty', 'empty'] instead of [['empty', 'empty', 'empty', 'empty'],['green', 'pink', 'empty', 'empty']], so, effectively, allowing the hints arrays to be limited to 4 elements)
      @hints_to_insert.clear

      # Initializing the correct colors and indexes variables to be 0
      @correct_colors = 0
      @correct_index = 0

      # Colors that are present in both the secret and user codes
      common_colors = user_code - (user_code - @secret_code)

      # Push into the outcome hash the lower value of the color count to contribute to the prevention of printing out more hints than necessary
      @secret_tally.each do |k1, v1|
        @user_tally.each do |k2, v2|
          @outcome[k2] << [v1, v2].min if k1 == k2
        end
      end

      # Iterate over each common color and if there are more colors in the user's code (e.g red-red-red-blue) than in the secret code (e.g red-red-blue-blue), delete the colors until there are no more than in the secret code. So the max amount of colors that is shown is that of the secret code.
      common_colors.each do |i|
        common_colors.delete_at(common_colors.find_index(i)) until common_colors.count(i) <= @outcome[i][0]
      end

      # For each coinciding index between a user's code and the secret, add 1 to the correct_index count.
      @correct_index += (@secret_code.each_index.select { |i| @secret_code[i] == user_code[i] }).length

      # The correct colors are equal to the length of the common colors after "processing"
      @correct_colors += common_colors.length

      # The empty hints are equal to what's left after the correct index and colors are shown
      @empty_hint = 4 - @correct_index - @correct_colors

      # Add a green hint/feedback for each correct index guess
      @correct_index.to_i.times do
        @hints_to_insert.push(@hint_hash['green'])
      end

      # Add a pink hint/feedback for each correct color guess that is not on the correct index
      (@correct_colors - @correct_index.to_i).times do
        @hints_to_insert.push(@hint_hash['pink'])
      end

      # Fill the rest of the feedback with empty hints, up to 4 (max amount of hints)
      @hints_to_insert.fill(@hint_hash['empty'], @hints_to_insert.length..4)

      # If in any case the hints to insert is an array that's bigger than 4, pop the last element, so the max allowed is 4
      @hints_to_insert.pop if @hints_to_insert.length > 4

      print_tiles
    end
  end

  # Method to print tiles
  def print_tiles
    # Clear the CLI
    system('clear')

    # Zip the array of all answers and hints feedbacks and "link them", so for each code, there is a separate set of hints
    @arr_answers.zip(@hints_check).each do |(first, second, third, fourth), (fifth, sixth, seventh, eight)|
      puts "#{"\n #{first}  #{second}  #{third}  #{fourth}"}  ||  #{fifth}  #{sixth}  #{seventh}  #{eight}\n\n"
    end

    # After printing the existing answers/hints, print out the rest of the empty tiles/hints, so the user knows how many are left (if there are 7 turns for example and the user already used 3 tries, print out 4 rows)
    puts "#{"\n #{Tile.empty_tile}  #{Tile.empty_tile}  #{Tile.empty_tile}  #{Tile.empty_tile}"}  ||  #{"#{Tile.empty_hint}  " * 4}\n\n" * (@turns - @arr_answers.length)

    # If the user is the winner, print out a congratulatory message and prompt for a restart/another round
    return unless @is_winner

    case role
    when '1'
      puts 'Congratulations! You cracked the code!'
    when '2'
      puts "The computer guessed your code in #{@turn - 1} tries! You lost this time!"
    end
    restart
  end

  # Method for restart
  def restart
    loop do
      puts "\nDo you want to play again? Please enter a valid option. [Y/N]"
      answer = gets.chomp
      case answer
      when 'Y', 'y', 'yes'.downcase
        Game.new
      when 'N', 'n', 'no'.downcase
        puts 'Thank you for playing Mastermind!'
        exit
      end
    end
  end
end
