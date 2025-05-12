require 'sinatra'
require './lib/hangperson_game'  # تأكد من أن هذا المسار صحيح
require 'json'

use Rack::Session::Cookie, secret: 'a_very_secure_super_long_key_that_is_definitely_more_than_sixty_four_characters_long_1234567890'
helpers do
  def get_game
    session[:game] ||= HangpersonGame.new('')
  end

  def hangman_ascii(wrong_guesses)
    stages = [
      <<~STAGE,
        <pre>
        +---+
        |   |
            |
            |
            |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
            |
            |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
        |   |
            |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
       /|   |
            |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
       /|\\  |
            |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
       /|\\  |
       /    |
            |
        =====
        </pre>
      STAGE
      <<~STAGE,
        <pre>
        +---+
        |   |
        O   |
       /|\\  |
       / \\  |
            |
        =====
        </pre>
      STAGE
    ]
    return stages[[wrong_guesses.to_i, stages.size - 1].min]
  end
  
  def play_hangman
    word = "ruby"
    guessed = []
    wrong_guesses = 0
    max_wrong = 6
  
    until wrong_guesses > max_wrong || (word.chars - guessed).empty?
      hangman_ascii(wrong_guesses)
      display_word = word.chars.map { |c| guessed.include?(c) ? c : "_" }.join(" ")
      puts "الكلمة: #{display_word}"
      print "أدخل حرفًا: "
      guess = gets.chomp.downcase
      if word.include?(guess)
        guessed << guess unless guessed.include?(guess)
      else
        wrong_guesses += 1
      end
    end
  
    if (word.chars - guessed).empty?
      puts "تهانينا! لقد فزت!"
    else
      hangman_ascii(wrong_guesses)
      puts "لقد خسرت. الكلمة كانت: #{word}"
    end
  end
  
  play_hangman  
  

  def generate_hint(word, guesses)
    if session[:level] && session[:level] >= 3
      "The word looks like: " + word.chars.map { |c| guesses.include?(c) ? c : '_' }.join
    else
      "The word starts with: #{word[0]}"
    end
  end
end

get '/' do
  game = get_game
  @word = game.word
  @guesses = game.guesses
  @wrong_guesses = game.wrong_guesses
  @ascii = hangman_ascii(game.wrong_guesses)
  @game_won = game.won?
  @game_lost = game.lost?
  @level = session[:level] || 1
  @hint = session[:hint]
  @sarcasm = sarcastic_remark if !@game_won && !@game_lost && game.wrong_guesses > 0
  erb :index
end

post '/new' do
  word = HangpersonGame.get_random_word
  session[:game] = HangpersonGame.new(word)
  session[:hint] = nil
  session[:level] ||= 1
  redirect '/'
end

post '/guess' do
  game = get_game
  letter = params[:guess].to_s[0]
  begin
    game.guess(letter)
    session[:level] += 1 if game.won?
  rescue ArgumentError
    @error = 'Invalid guess.'
  end
  redirect '/'
end

post '/hint' do
  game = get_game
  session[:hint] = generate_hint(game.word, game.guesses)
  redirect '/'
end

