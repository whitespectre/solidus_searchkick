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
      # Check if searchkick_options have been set by the application using this gem
      # If they have, then do not initialize searchkick on the model
      # If they have not, then set the defaults
      unless ::Spree::Product.try(:searchkick_options)
        ::Spree::Product.class_eval do
          searchkick(
            index_name: "#{Rails.application.class.module_parent_name.parameterize.underscore}_spree_products_#{Rails.env}",
            word_start: [:name]
          )
        end
      end

      unless ::Spree::Taxon.try(:searchkick_options)
        ::Spree::Taxon.class_eval do
          searchkick(
            index_name: "#{Rails.application.class.module_parent_name.parameterize.underscore}_spree_taxons_#{Rails.env}",
            word_start: [:name]
          )
        end
      end
    end
  end
end
