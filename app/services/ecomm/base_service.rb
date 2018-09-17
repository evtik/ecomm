module Ecomm
  class BaseService
    class << self
      def call(*args)
        build.call(*args)
      end

      def build
        new
      end
    end
  end
end
