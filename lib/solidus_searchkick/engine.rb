# frozen_string_literal: true

require 'spree/core'

module SolidusSearchkick
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions::Decorators

    isolate_namespace ::Spree

    engine_name 'solidus_searchkick'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_searchkick.setup_decorators' do |app|
      if Rails.autoloaders.respond_to?(:main) && Rails.autoloaders.main.respond_to?(:ignore)
        Rails.autoloaders.main.ignore(Dir.glob(File.join(File.dirname(__FILE__), '../../app/decorators')))
      end
    end

    config.to_prepare do
      ActionView::Base.send :include, SolidusSearchkick::Helpers::FormHelper

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/decorators/**/*.rb')).sort.each do |file|
        require_dependency file
      end
    end

    # Run after initialization, allows us to process product_decorator from application before this
    config.after_initialize do
      if ::SolidusSearchkick.autosetup
        ::SolidusSearchkick.setup_index(::Spree::Product)
        ::SolidusSearchkick.setup_index(::Spree::Taxon)
      end
    end
  end
end
