require 'sinatra'
require './lib/hangperson_game'
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

  def generate_hint(word, guesses)
    if session[:level] && session[:level] >= 3
      "The word looks like: " + word.chars.map { |c| guesses.include?(c) ? c : '_' }.join
    else
      "The word starts with: #{word[0]}"
    end
  end

  def sarcastic_remark
    [
      "😏 Really? That was your guess?",
      "🙄 My pet rock could guess better.",
      "😬 Try using your brain this time.",
      "😅 You're making this way too easy for the hangman.",
      "🤣 Are you even trying?"
    ].sample
  end
end

# ROUTES

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
