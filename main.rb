require 'sinatra'
require './lib/hangperson_game'
require 'json'

use Rack::Session::Cookie, secret: 'a_very_secure_super_long_key_that_is_definitely_more_than_sixty_four_characters_long_1234567890'

WORDS = %w[
  apple banana orange strawberry watermelon pineapple
  mango cherry foggy thunder cozy blanket pillow whisper
  silence mirror candle window sunrise sunset forest
  mountain river desert cloud ocean storm breeze rain
  rainbow thunderstorm peace joy laughter sadness shadow
  courage freedom umbrella suitcase journal slipper cactus
  perfume guitar dream hope kindness thunderbolt snowflake
  meadow fireplace hammock bubble
]

HINTS = {
  'apple' => 'A common red fruit.',
  'banana' => 'A long yellow fruit.',
  'orange' => 'A round orange citrus.',
  'strawberry' => 'A small red berry.',
  'watermelon' => 'A large green fruit with red inside.',
  'pineapple' => 'A tropical fruit with spiky skin.',
  'mango' => 'A juicy tropical fruit.',
  'cherry' => 'A small red stone fruit.',
  'foggy' => 'Low visibility due to mist.',
  'thunder' => 'A loud sound after lightning.',
  'cozy' => 'Warm and comfortable feeling.',
  'blanket' => 'Keeps you warm while sleeping.',
  'pillow' => 'Supports your head at night.',
  'whisper' => 'Talking very softly.',
  'silence' => 'Complete absence of sound.',
  'mirror' => 'Reflects your appearance.',
  'candle' => 'Wax stick with a flame.',
  'window' => 'Let’s you see outside.',
  'sunrise' => 'When the sun first appears.',
  'sunset' => 'When the sun goes down.',
  'forest' => 'A large area full of trees.',
  'mountain' => 'A high natural elevation.',
  'river' => 'A flowing body of water.',
  'desert' => 'Dry land with little rain.',
  'cloud' => 'White puffs in the sky.',
  'ocean' => 'A vast body of salt water.',
  'storm' => 'Heavy rain with thunder.',
  'breeze' => 'A soft gentle wind.',
  'rain' => 'Water falling from the sky.',
  'rainbow' => 'Colorful arc after rain.',
  'thunderstorm' => 'A storm with thunder and lightning.',
  'peace' => 'A calm and quiet state.',
  'joy' => 'A strong feeling of happiness.',
  'laughter' => 'The sound of amusement.',
  'sadness' => 'The opposite of happiness.',
  'shadow' => 'Dark shape caused by blocking light.',
  'courage' => 'Bravery in the face of fear.',
  'freedom' => 'The power to act or speak freely.',
  'umbrella' => 'Used to protect from rain.',
  'suitcase' => 'Used for packing clothes.',
  'journal' => 'A book to write daily thoughts.',
  'slipper' => 'Soft indoor shoe.',
  'cactus' => 'A spiky desert plant.',
  'perfume' => 'A liquid that smells pleasant.',
  'guitar' => 'A musical instrument with strings.',
  'dream' => 'Thoughts while sleeping or goals.',
  'hope' => 'Belief that good things will happen.',
  'kindness' => 'Being nice and caring to others.',
  'thunderbolt' => 'A sudden flash of lightning.',
  'snowflake' => 'Unique frozen crystal from the sky.',
  'meadow' => 'A field full of grass and flowers.',
  'fireplace' => 'A warm place where fire burns inside.',
  'hammock' => 'A swinging bed made of netting.',
  'bubble' => 'A sphere made of soap and air.'
}

helpers do
  def get_game
    word = session[:word] || WORDS.sample
    guesses = session[:guesses] || []
    wrong_guesses = session[:wrong_guesses] || []
    HangpersonGame.new(word, guesses, wrong_guesses)
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
    stages[[wrong_guesses.to_i, stages.size - 1].min]
  end

  def generate_hint(word, guesses)
    if session[:level] && session[:level] >= 3
      "The word looks like: " + word.chars.map { |c| guesses.include?(c) ? c : '_' }.join
    else
      HINTS[word] || "The word starts with: #{word[0]}"
    end
  end

  def sarcastic_remark
    [
      "😏 Really? That was your guess?",
      "🙄 seriously? Is this all you can do?",
      "😬 Try using your brain this time.",
      "😅 You're making this way too easy for the hangman.",
      "🤣 Are you even trying?",
      "😏 Are you wishing or guessing?"
    ].sample
  end
end

get '/' do
  game = get_game
  @ascii = hangman_ascii(game.wrong_guesses)
  @word = game.word
  @guesses = game.guesses
  @wrong_guesses = game.wrong_guesses
  @game_won = game.won?
  @game_lost = game.lost?
  @level = session[:level] || 1
  @hint = session[:hint]
  @sarcasm = sarcastic_remark if !@game_won && !@game_lost && game.wrong_guesses > 0
  erb :index
end

post '/new' do
  word = WORDS.sample
  session[:word] = word
  session[:guesses] = []
  session[:wrong_guesses] = []
  session[:hint] = nil
  session[:level] ||= 1
  redirect '/'
end

post '/guess' do
  game = get_game
  letter = params[:guess].to_s[0]
  begin
    game.guess(letter)
    session[:guesses] = game.guesses
    session[:wrong_guesses] = game.wrong_guesses
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
