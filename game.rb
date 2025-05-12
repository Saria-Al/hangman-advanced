class Game
  attr_reader :word, :guesses

  def initialize(word, guesses)
    @word = word
    @guesses = guesses
  end

  def display_word
    @word.chars.map { |char| @guesses.include?(char) ? char : '_' }.join(' ')
  end

  def remaining_letters
    (@word.chars - @guesses).uniq
  end

  def guessed_correctly?
    remaining_letters.empty?
  end

  def incorrect_guesses
    @guesses.reject { |char| @word.include?(char) }
  end

  def wrong_count
    incorrect_guesses.size
  end
end
