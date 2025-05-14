require 'capybara/cucumber'
require 'capybara'
require 'rspec/expectations'
require 'selenium-webdriver'
require_relative '../../main'

Capybara.default_driver = :selenium_chrome_headless # أو استخدم :selenium_chrome لعرض المتصفح
Capybara.app = Sinatra::Application
