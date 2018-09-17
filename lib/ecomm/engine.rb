# require 'activerecord-session_store'
require 'attr_extras'
require 'bootstrap-sass'
require 'countries/global'
require 'draper'
require 'hamlit'
require 'i18n-js'
require 'jquery-rails'
require 'money-rails'
require 'rectify'
require 'sass-rails'
require 'simple_form'
require 'wisper'

if Rails.env == 'test'
  require 'carrierwave'
  require 'devise'
end

module Ecomm
  class Engine < ::Rails::Engine
    def self.app_path
      File.expand_path('../../app', called_from)
    end

    wd = Dir.getwd
    Dir.chdir(app_path)

    (Dir['*'] - %w(assets jobs views)).each do |dir|
      class_eval <<-HEREDOC, __FILE__, __LINE__ + 1
        def self.#{dir}_path(name)
          File.expand_path("#{dir}/ecomm/\#{name}", app_path)
        end
      HEREDOC
    end

    Dir.chdir(wd)

    isolate_namespace Ecomm

    config.generators do |g|
      g.test_framework      :rspec,        fixture: false
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
