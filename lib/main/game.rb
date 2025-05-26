require_relative "word_checker"
require_relative "saver"

class Game
  def initialize
    @checker = WordChecker.new
    @blanks = []
    @incorrect = []
  end

  def setup_game
    @incorrect = []
    @blanks = Array.new(@checker.generate.length) { "_" }
    @num_incorrect = 7
  end

  def start
    if File.exist?("main/save.txt")
      puts "Save file exists. Do you want to play saved game?(y/n)"
      gets.chomp == "y" ? load_game : setup_game
    else
      setup_game
    end
    play
  end

  def load_game
    state = Saver.load
    @incorrect = state[:incorrect]
    @blanks = state[:blanks]
    @checker.word = state[:word]
    @num_incorrect = state[:num_incorrect]
  end

  def play
    loop do
      while @num_incorrect > 0
        puts "Tries left: #{@num_incorrect}"
        print_incorrects
        print_blanks
        @num_incorrect -= 1 unless process_guess(get_guess)
        break if check_win
      end
      check_loss
      break unless play_again?

      setup_game
    end
    @checker.end_game
  end

  def print_incorrects
    print "Incorrect #{@incorrect}"
    puts
  end

  def play_again?
    puts "Play again?(y/n)"
    gets.chomp.downcase == "y"
  end

  def print_blanks
    @blanks.length.times do |i|
      print "#{@blanks[i]} "
    end
    puts
  end

  def check_win
    return if @blanks.include?("_")

    puts "You win"
    true
  end

  def check_loss
    return if @num_incorrect > 0

    puts "You lose. The word is #{@checker.word}."
  end

  def save_game
    Saver.save(@blanks, @incorrect, @checker.word, @num_incorrect)
  end

  def get_guess
    guess = ""
    loop do
      puts "Put in your guess:"
      guess = gets.chomp.downcase
      if guess == "save"
        save_game
        puts "Game saved"
        next
      end
      break if guess.length == 1 && ("a".."z").include?(guess) && !@incorrect.include?(guess)

      puts "Invalid Input"
    end
    guess
  end

  def process_guess(char)
    indexes = @checker.check_word(char)
    if indexes.empty?
      @incorrect.push(char)
      return false
    end

    indexes.each do |i|
      @blanks[i] = char
    end
    true
  end
end
