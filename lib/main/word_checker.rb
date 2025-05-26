class WordChecker
  attr_accessor :word

  def initialize
    @file = File.open("main/words.txt", "r")
    @word = ""
  end

  def generate
    @file.rewind
    index = rand(9893)
    word = ""
    index.times do
      word = @file.gets.chomp
    end
    @word = word
    word
  end

  def check_word(char)
    indexes = []
    offset = 0
    while (index = @word.index(char, offset))
      indexes.push(index)
      offset = index + 1
    end
    indexes
  end

  def end_game
    @file.close
  end
end
