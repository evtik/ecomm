describe Ecomm::CreditCardForm, type: :form do
  context 'number' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to allow_value('4149625323094647').for(:number) }
    it { is_expected.not_to allow_value('1234').for(:number) }
    it { is_expected.not_to allow_value('abcd').for(:number) }
    it { is_expected.not_to allow_value('5149625323094647').for(:number) }
  end

  context 'cardholder' do
    it { is_expected.to validate_presence_of(:cardholder) }
    it { is_expected.to allow_value('John Smith').for(:cardholder) }
    it { is_expected.to allow_value('JOHN SMITH').for(:cardholder) }
    it { is_expected.not_to allow_value('John-Smith').for(:cardholder) }
    it { is_expected.not_to allow_value('John Smith 3rd').for(:cardholder) }
  end

  context 'month_year' do
    let(:current_month) { Date.today.strftime '%m' }
    let(:current_year) { Date.today.strftime '%y' }
    let(:future_month) { (Date.today + 1.month).strftime '%m' }
    let(:future_year) { (Date.today + 1.month).strftime '%y' }
    let(:past_month) { (Date.today - 1.month).strftime '%m' }
    let(:past_year) { (Date.today - 1.month).strftime '%y' }

    it { is_expected.to validate_presence_of(:month_year) }

    it do
      is_expected.to allow_value(
        "#{current_month}/#{current_year}"
      ).for(:month_year)
    end

    it do
      is_expected.to allow_value(
        "#{future_month}/#{future_year}"
      ).for(:month_year)
    end

    it do
      is_expected.not_to allow_value(
        "#{past_month}/#{past_year}"
      ).for(:month_year)
    end

    it do
      is_expected.not_to allow_value(
        "00/#{future_year}"
      ).for(:month_year)
    end

    it do
      is_expected.not_to allow_value(
        "13/#{future_year}"
      ).for(:month_year)
    end

    it { is_expected.not_to allow_value('1212').for(:month_year) }
    it { is_expected.not_to allow_value('1/12').for(:month_year) }
    it { is_expected.not_to allow_value('12/2').for(:month_year) }
    it { is_expected.not_to allow_value('ab/cd').for(:month_year) }
  end

  context 'cvv' do
    it { is_expected.to validate_presence_of(:cvv) }
    it { is_expected.to allow_value('123').for(:cvv) }
    it { is_expected.to allow_value('4567').for(:cvv) }
    it { is_expected.not_to allow_value('1 2').for(:cvv) }
    it { is_expected.not_to allow_value('1 23').for(:cvv) }
    it { is_expected.not_to allow_value('1abc').for(:cvv) }
  end
end
