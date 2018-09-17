class NewAddressForm
  include Capybara::DSL

  def initialize(entity, type)
    @entity = entity
    @type = type
  end

  def fill_in_form(params)
    fill_in("#{@entity}[#{@type}][first_name]", with: params[:first_name])
    fill_in("#{@entity}[#{@type}][last_name]", with: params[:last_name])
    fill_in("#{@entity}[#{@type}][street_address]", with: params[:street_address])
    fill_in("#{@entity}[#{@type}][city]", with: params[:city])
    fill_in("#{@entity}[#{@type}][zip]", with: params[:zip])
    select(params[:country], from: "#{@entity}[#{@type}][country]")
    fill_in("#{@entity}[#{@type}][phone]", with: params[:phone])
  end
end
