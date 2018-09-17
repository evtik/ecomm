ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails-controller-testing'
require 'rspec/rails'
require 'faker'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'rack_session_access/capybara'
require 'shoulda/matchers'
require 'wisper/rspec/matchers'

Rails.backtrace_cleaner.remove_silencers!

%w(support helpers **/shared_examples).each do |folder|
  Dir["#{File.dirname(__FILE__)}/../spec/#{folder}/**/*.rb"].each do |file|
    require file
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    browser: :phantomjs,
    window_size: [1280, 1024],
    js_errors: true,
    debug: false
  )
end

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, type: :feature do |example|
    if example.metadata[:use_selenium]
      saved_driver = Capybara.current_driver
      Capybara.current_driver = :selenium
    end

    example.run

    Capybara.current_driver = saved_driver if example.metadata[:use_selenium]
  end

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.include Wisper::RSpec::BroadcastMatcher
  config.include AbstractController::Translation
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Shoulda::Matchers::ActiveModel, type: :form
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include Ecomm::TranslationHelpers, :include_translation_helpers
  config.include Ecomm::Engine.routes.url_helpers, type: :command
end
