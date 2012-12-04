module Creative
module Machine

  class Haiku
    SOURCE_WORDS_FILE = File.dirname(__FILE__) + "/../../../data/haiku.txt"
    
    LINES = 3
    SYLLABLES_PER_LINE = [5, 7, 5]
    
    def initialize(lines)
      @lines = lines
    end
    
    def length
      @lines.length
    end

    def words
      @lines.flatten
    end
    
    def to_s
      @lines.map{|line| line.join(" ")}.join("\n")
    end

    def line(index)
      @lines[index]
    end

    def syllables_for_line(line_index)
      SYLLABLES_PER_LINE[line_index]
    end

    def replace_line(line_index, new_line)
      @lines[line_index] = new_line
    end

    def replace_word(word_index, line_index, new_word)
      @lines[line_index][word_index] = new_word
    end

    def pick_random_line
      line_index = Kernel.rand(length)
      line = @lines[line_index]

      [line, line_index]
    end

    def pick_random_word
      line, line_index = *pick_random_line
      word_index = Kernel.rand(line.length)

      [line[word_index], word_index, line_index]
    end

  end
  
end
end