$:.push File.expand_path("../lib", __FILE__)

require 'ecomm/version'

Gem::Specification.new do |s|
  s.name        = 'ecomm'
  s.version     = Ecomm::VERSION
  s.authors     = ['Serhiy Yevtushenko']
  s.email       = ['serhiy.yevtushenko@gmail.com']
  s.homepage    = 'http://github.com/evtik/ecomm'
  s.summary     = 'Cart/Checkout Rails Engine'
  s.description = 'A very simple cart and checkout for an online store'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile',
                'README.md']

  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activerecord-session_store'
  s.add_dependency 'attr_extras'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'countries'
  s.add_dependency 'draper'
  s.add_dependency 'hamlit'
  s.add_dependency 'hamlit-rails'
  s.add_dependency 'i18n-js'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'money-rails'
  s.add_dependency 'pg'
  s.add_dependency 'rails', '~> 5.1.6'
  s.add_dependency 'rails-i18n'
  s.add_dependency 'rectify'
  s.add_dependency 'sass-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'wisper'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'carrierwave'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'letter_opener'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rack_session_access'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'wisper-rspec'
end
