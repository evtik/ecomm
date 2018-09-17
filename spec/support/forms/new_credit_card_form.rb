class NewCreditCardForm
  include AbstractController::Translation
  include Capybara::DSL

  def fill_in_with(params)
    fill_in('order[card][number]', with: params[:number])
    fill_in('order[card][cardholder]', with: params[:cardholder])
    fill_in('order[card][month_year]', with: params[:month_year])
    fill_in('order[card][cvv]', with: params[:cvv])
    self
  end

  def submit
    click_on(t('ecomm.checkout.save_continue'))
  end
end
