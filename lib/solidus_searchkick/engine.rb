module SolidusSearchkick
  class Engine < Rails::Engine
    require 'spree/core'
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
            index_name: "#{Rails.application.class.parent_name.parameterize.underscore}_spree_products_#{Rails.env}",
            word_start: [:name]
          )
        end
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      ::Spree::Config.searcher_class = ::Spree::Search::Searchkick
    end

    config.to_prepare &method(:activate).to_proc
  end
end
