require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'json'

class HangmanApp < Sinatra::Base
  configure do
    set :public_folder, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :bind, '0.0.0.0'
    set :port, ENV['PORT']
    set :environment, :production
  end

  WORDS = %w[
    apple banana orange lemon mango peach pear grape melon kiwi
    rocket planet jungle button camera garden window mirror pillow remote
    python diamond cyclone pyramid blanket zephyr lantern mystery thunder whisper
  ]

  HINTS = {
    'apple' => 'A common red or green fruit.',
    'banana' => 'A long curved yellow fruit.',
    'orange' => 'A round citrus fruit and a color.',
    'lemon' => 'A sour yellow fruit.',
    'mango' => 'A sweet tropical fruit.',
    'peach' => 'A soft fruit with fuzzy skin.',
    'pear' => 'A green fruit shaped like a teardrop.',
    'grape' => 'Small purple or green fruit, often in bunches.',
    'melon' => 'A large juicy fruit with seeds.',
    'kiwi' => 'A brown fuzzy fruit with green inside.',
    'rocket' => 'Used to launch into space.',
    'planet' => 'A celestial body orbiting a star.',
    'jungle' => 'A dense forest with wild animals.',
    'button' => 'Pressed to control something.',
    'camera' => 'Used to take pictures.',
    'garden' => 'A place where plants and flowers grow.',
    'window' => 'An opening in a wall to let light in.',
    'mirror' => 'You see your reflection in it.',
    'pillow' => 'You rest your head on it while sleeping.',
    'remote' => 'Used to control a TV from a distance.',
    'python' => 'A large snake or a programming language.',
    'diamond' => 'A precious stone, very hard.',
    'cyclone' => 'A violent rotating windstorm.',
    'pyramid' => 'A triangle-shaped structure in Egypt.',
    'blanket' => 'Used to keep you warm in bed.',
    'zephyr' => 'A soft gentle breeze.',
    'lantern' => 'A portable light, often with a handle.',
    'mystery' => 'Something unexplained or puzzling.',
    'thunder' => 'Loud sound after lightning.',
    'whisper' => 'To speak very softly.'
  }

  enable :sessions

  helpers do
    def sarcastic_remark
      [
        "Seriously?", "Try harder!", "You're killing me!",
        "Is this guessing or wishing?", "Are you even trying?"
      ].sample
    end

    def hangman_ascii(wrong_guesses)
      stages = [
        "<pre>  +---+\n      |\n      |\n      |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n      |\n      |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n  |   |\n      |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n /|   |\n      |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n /|\\  |\n      |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n /|\\  |\n /    |\n     ===</pre>",
        "<pre>  +---+\n  O   |\n /|\\  |\n / \\  |\n     ===</pre>"
      ]
      stages[[wrong_guesses, stages.size - 1].min]
    end

    def game_won?
      (session[:word].chars - session[:guesses]).empty?
    end

    def game_lost?
      session[:wrong_guesses] >= 6
    end

    # ✅ تستخدم نوع التلميح بناء على مستوى اللعب أو وضع افتراضي
    def generate_hint(word, guesses)
      if session[:level] && session[:level] >= 3
        "The word looks like: " + word.chars.map { |c| guesses.include?(c) ? c : '_' }.join
      else
        "The word starts with: #{word[0]}"
      end
    end
  end

  get '/' do
    session.clear
    redirect '/new'
  end

  get '/new' do
    word = WORDS.sample
    session[:word] = word
    session[:guesses] = []
    session[:wrong_guesses] = 0
    session[:hint] = nil
    session[:level] ||= 1
    erb :index
  end

  post '/guess' do
    letter = params[:letter].downcase
    unless session[:guesses].include?(letter)
      session[:guesses] << letter
      session[:wrong_guesses] += 1 unless session[:word].include?(letter)
    end

    session[:level] += 1 if game_won?
    redirect '/game'
  end

  get '/game' do
    @game_won = game_won?
    @game_lost = game_lost?
    @sarcasm = sarcastic_remark if !@game_won && !@game_lost && session[:wrong_guesses] > 0
    erb :index
  end

  post '/hint' do
    session[:hint] = generate_hint(session[:word], session[:guesses])
    redirect back
  end

  run! if __FILE__ == $PROGRAM_NAME
end
