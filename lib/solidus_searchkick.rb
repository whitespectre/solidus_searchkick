# frozen_string_literal: true

require 'searchkick'
require 'solidus_core'
require 'solidus_support'

require 'solidus_searchkick/version'
require 'solidus_searchkick/engine'
require 'solidus_searchkick/railtie' if defined?(Rails)

module SolidusSearchkick
  def self.root
    File.expand_path('../..',__FILE__)
  end
end
