module SolidusSearchkick
  module IndexFactory
    extend self

    def call(klass, locales)
      result = { word_start: [:name] }
      if locales.present?
        result.merge!(index_name: proc { "#{to_index_name(klass)}_#{I18n.locale}" }, language: proc { locales.fetch(I18n.locale) })
      else
        result[:index_name] = to_index_name(klass)
      end
      result
    end

    private

    def to_index_name(klass)
      app_name = Rails.application.class.module_parent_name.parameterize.underscore
      "#{app_name}_#{klass.model_name.plural}_#{Rails.env}"
    end
  end
end
