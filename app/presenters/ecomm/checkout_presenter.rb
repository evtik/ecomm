module Ecomm
  class CheckoutPresenter < Rectify::Presenter
    def steps
      Ecomm.checkout_steps
    end

    def populate_countries_for(address_type)
      @countries ||= Ecomm::Common::GetCountries.call.map do |country|
        [country[0], { data: { 'country-code' => country[1] } }]
      end

      @countries.map do |country|
        [country[0], country[1].merge(class: address_type)]
      end
    end

    def previous?(step, action)
      steps.index(step) < steps.index(action.to_sym)
    end

    def current?(step, action)
      steps.index(step) == steps.index(action.to_sym)
    end

    def starred_number(card)
      "** ** ** #{card.number[-4..-1]}"
    end

    def month_full_year(card)
      ('' << card.month_year).insert(3, '20')
    end
  end
end
