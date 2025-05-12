class HangpersonGame
  attr_reader :word, :guesses, :wrong_guesses

  def initialize(word, guesses = [], wrong_guesses = [])
    @word = word.downcase
    @guesses = guesses
    @wrong_guesses = wrong_guesses
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.empty? || !(letter =~ /[a-zA-Z]/)
    letter.downcase!
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include? letter
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : '_' }.join
  end

  def won?
    word_with_guesses == @word
  end

  def lost?
    @wrong_guesses.length >= 7
  end

  def self.get_random_word
    %w[apple banana orange mango thunder shadow rainbow cozy freedom courage mountain].sample
  end
end
