class HangpersonGame
  attr_reader :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = []
    @wrong_guesses = []
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

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  def self.get_random_word
    # You can replace this list with a real API or file read
    %w[apple banana orange mango pyramid python garden thunder].sample
  end

  def won?
    word_with_guesses == @word
  end

  def lost?
    @wrong_guesses.length >= 7
  end
end
