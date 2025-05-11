# spec/hangman_spec.rb
require 'rspec'

describe "Hangman logic" do
  it "adds correct guesses" do
    session = { word: 'apple', guesses: [] }
    letter = 'a'
    session[:guesses] << letter unless session[:guesses].include?(letter)
    expect(session[:guesses]).to include(letter)
  end

  it "does not add duplicate guesses" do
    session = { word: 'apple', guesses: ['a'] }
    letter = 'a'
    session[:guesses] << letter unless session[:guesses].include?(letter)
    expect(session[:guesses].count(letter)).to eq(1)
  end
end
