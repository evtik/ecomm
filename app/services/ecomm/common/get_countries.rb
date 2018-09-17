module Ecomm
  module Common
    class GetCountries < BaseService
      def call
        Country.all { |_x, data| [data['name'], data['country_code']] }.sort
      end
    end
  end
end
