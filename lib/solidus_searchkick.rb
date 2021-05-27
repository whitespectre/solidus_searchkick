# frozen_string_literal: true

require 'searchkick'
require 'solidus_core'
require 'solidus_support'
require 'solidus_searchkick/version'
require 'solidus_searchkick/engine'
require 'solidus_searchkick/railtie'
require 'solidus_searchkick/index_factory'

module SolidusSearchkick
  mattr_accessor :autosetup
  self.autosetup = true

  mattr_accessor :locales

  module MultiLocaleReindex
    module ClassMethods
      def reindex(*args, &block)
        SolidusSearchkick.each_locale { super }
      end
    end

    def self.prepended(klass)
      klass.singleton_class.prepend(ClassMethods)
    end

    def reindex(*args, &block)
      SolidusSearchkick.each_locale { super }
    end
  end

  def self.root
    File.expand_path('../..',__FILE__)
  end

  # Check if searchkick_index have been set by the application using this gem
  # If they have, then do not initialize searchkick on the model
  # If they have not, then set the defaults
  def self.setup_index(klass, custom = {})
    return if klass.respond_to?(:searchkick_index)

    klass.searchkick(IndexFactory.call(klass, locales).deep_merge!(custom))
    klass.prepend(MultiLocaleReindex) if locales
  end

  def self.each_locale(&block)
    locales.keys.each { |locale| I18n.with_locale(locale, &block) }
  end
end
