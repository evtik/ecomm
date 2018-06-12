ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails-controller-testing'
require 'rspec/rails'
require 'faker'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'rack_session_access/capybara'
require 'wisper/rspec/matchers'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/../spec/support/**/*.rb"].each { |f| require f }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    browser: :phantomjs,
    window_size: [1280, 1024],
    js_errors: true,
    debug: false
  )
end

Capybara.current_driver = :poltergeist

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
  # config.include Rails.application.routes.url_helpers
end
