require 'capybara/cucumber'
require 'capybara'
require 'rspec/expectations'
require_relative '../../main'  # تأكد من المسار حسب بنية مجلدك

Capybara.app = HangmanApp
