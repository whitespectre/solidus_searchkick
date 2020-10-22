# frozen_string_literal: true

require 'searchkick'
require 'solidus_core'
require 'solidus_support'
require 'solidus_searchkick/version'
require 'solidus_searchkick/engine'
require 'solidus_searchkick/railtie'

module SolidusSearchkick
  mattr_accessor :autosetup
  self.autosetup = true

  def self.root
    File.expand_path('../..',__FILE__)
  end

  # Check if searchkick_index have been set by the application using this gem
  # If they have, then do not initialize searchkick on the model
  # If they have not, then set the defaults
  def self.setup_class(klass, custom = {})
    return if klass.respond_to?(:searchkick_index)
    klass.searchkick({ index_name: to_index_name(klass), word_start: [:name] }.deep_merge!(custom))
  end

  def self.to_index_name(klass)
    app_name = Rails.application.class.module_parent_name.parameterize.underscore
    "#{app_name}_#{klass.model_name.plural}_#{Rails.env}"
  end
end
