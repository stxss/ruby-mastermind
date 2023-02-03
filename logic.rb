
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
    # From the @codes variable, depending on the user preferences, take a random 4 digit code and make it the secret code
    @secret_code = []
    @player_code = []
    if role == '1'
      @secret_code = @codes.sample
    elsif role == '2'
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
    if role == '1'
      4.times do |i|
        color_set(i)
      end
    elsif role == '2'
      # In the case of the player choosing to be the codemaker, proceed with the condition where the computer follows an algorithm to try and break the code
      4.times do |i|
        color_set_computer(i)
      end
    end

    # Check the colors
    color_check

    # Advance to the next turn
    @turn += 1
  end

  def get_code(i)
    @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
        't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

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
    puts "\nInsert the #{ordinal} digit/color of your secret code: "
    loop do
      color = gets.chomp
      break if @responses.include?(color)
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

    @player_code.insert(i, color.to_i)
    print "\n\e[A\e[A\e[K"
  end

  def print_code
    puts "Your code is : #{@@color_hash[@player_code[0].to_s]} #{@@color_hash[@player_code[1].to_s]} #{@@color_hash[@player_code[2].to_s]} #{@@color_hash[@player_code[3].to_s]}"
  end

  # Method for manual setting of colors
  def color_set(idx)
    # Possible responses
    @responses = ['0', '1', '2', '3', '4', '5', '6', 'blank'.downcase, 'r'.downcase, 'g'.downcase, 'b'.downcase, 'o'.downcase, 'v'.downcase,
                  't'.downcase, 'red'.downcase, 'green'.downcase, 'blue'.downcase, 'orange'.downcase, 'violet'.downcase, 'teal'.downcase]

    # Initiating the user response as an empty string
    user_response = ''

    # Asking the user until they give a valid response
    puts 'Please, enter a color/number of your choice'
    loop do
      user_response = gets.chomp
      break if @responses.include?(user_response)
    end

    # In case the answer is not a number but a letter or color, correspond it to the number
    case user_response
    when 'blank'.downcase
      user_response = '0'
    when 'r'.downcase, 'red'.downcase
      user_response = '1'
    when 'g'.downcase, 'green'.downcase
      user_response = '2'
    when 'b'.downcase, 'blue'.downcase
      user_response = '3'
    when 'o'.downcase, 'orange'.downcase
      user_response = '4'
    when 'v'.downcase, 'violet'.downcase
      user_response = '5'
    when 't'.downcase, 'teal'.downcase
      user_response = '6'
    end

    # Insert the answer as a code to the checking array to compare it with the secret code
    @ans_to_check.insert(idx, user_response.to_i)

    # Inserting the answer as a color tile to display it to the user
    @answers.insert(idx, @@color_hash[user_response])

    # Clear the CLI
    system('clear')

    # Delete the last item from the arrays above, as the method inserts answers at the start and doesn't overwrite anything, so to prevent having 8-length arrays, for each response input, the last element is deleted. This way it is possible to have only arrays with 4 items
    @answers.delete_at(-1)
    @ans_to_check.delete_at(-1)

    # Print out the board
    print_tiles
  end

  # Method for computational setting of the colors
  def color_set_computer(idx)
    # Possible responses
    @responses = ['0', '1', '2', '3', '4', '5', '6']

    # Initiating the user response as an empty string
    computer_response = ''

    # Asking the user until they give a valid response
    loop do
      computer_response = computer_guess(@turn - 1, idx)
      break if @responses.include?(computer_response)
    end

    # Insert the answer as a code to the checking array to compare it with the secret code
    @ans_to_check.insert(idx, computer_response.to_i)

    # Inserting the answer as a color tile to display it to the user
    @answers.insert(idx, @@color_hash[computer_response])

    # Clear the CLI
    system('clear')

    # Delete the last item from the arrays above, as the method inserts answers at the start and doesn't overwrite anything, so to prevent having 8-length arrays, for each response input, the last element is deleted. This way it is possible to have only arrays with 4 items
    @answers.delete_at(-1)
    @ans_to_check.delete_at(-1)

    # Print out the board
    # color_check
    print_tiles
  end

  def computer_guess(order, idx)
    guess = ''
    @new_codes = @codes
    if order == 0
      case idx
      when 0
        guess = '0'
      when 1
        guess = '0'
      when 2
        guess = '1'
      when 3
        guess = '1'
      end
    elsif order > 0
      # puts "#{@new_codes}"
      case idx
      when 0
        guess = '1'
      when 1
        guess = '1'
      when 2
        guess = '1'
      when 3
        guess = '1'
      end
    end
    puts @hints_to_insert
    sleep(1)
    guess
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

    puts 'Congratulations! You cracked the code!'
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
