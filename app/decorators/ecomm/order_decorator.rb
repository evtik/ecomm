module Ecomm
  class OrderDecorator < Draper::Decorator
    delegate_all

    def number
      id = model.id.to_s
      'R' << '0' * (8 - id.length) << id
    end
  end
end
