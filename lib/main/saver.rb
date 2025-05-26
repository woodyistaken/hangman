require "yaml"

class Saver
  def self.save(blanks, incorrect, word, num_incorrect)
    file = File.open("main/save.txt", "w")
    file.puts YAML.dump({ blanks: blanks, incorrect: incorrect, word: word, num_incorrect: num_incorrect })
  end

  def self.load
    yml = File.read("main/save.txt")
    YAML.load(yml)
  end
end
