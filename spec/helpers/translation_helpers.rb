module Ecomm
  module TranslationHelpers
    %i(blank invalid).each do |error|
      define_method("attr_#{error}_error") do |model, attribute|
        t("activemodel.errors.models.#{model}.attributes.#{attribute}.#{error}")
      end
    end
  end
end
