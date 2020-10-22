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

    # Run after initialization, allows us to process product_decorator from application before this
    config.after_initialize do
      if ::SolidusSearchkick.autosetup
        ::SolidusSearchkick.setup_class(::Spree::Product)
        ::SolidusSearchkick.setup_class(::Spree::Taxon)
      end
    end
  end
end
