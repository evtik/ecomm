describe Ecomm::CheckoutPresenter do
  context '#populate_countries_for' do
    before do
      allow(Ecomm::Common::GetCountries).to receive(:call).and_return(
        [['Spain', '123'], ['Wales', '321']]
      )
    end

    it "returns modified countries array with 'billing' css class" do
      expect(subject.populate_countries_for('billing')).to eq(
        [['Spain', { data: { 'country-code' => '123' }, class: 'billing' }],
         ['Wales', { data: { 'country-code' => '321' }, class: 'billing' }]]
      )
    end

    it "returns modified countries array with 'shipping' css class" do
      expect(subject.populate_countries_for('shipping')).to eq(
        [['Spain', { data: { 'country-code' => '123' }, class: 'shipping' }],
         ['Wales', { data: { 'country-code' => '321' }, class: 'shipping' }]]
      )
    end
  end

  context '#previous?' do
    it 'returns true for any previous step' do
      expect(subject.previous?(:address, 'confirm')).to be true
    end

    it 'returns false for current step' do
      expect(subject.previous?(:payment, 'payment')).to be false
    end

    it 'returns false for any further step' do
      expect(subject.previous?(:complete, 'delivery')).to be false
    end
  end

  context '#current?' do
    it 'returns false for any previous step' do
      expect(subject.current?(:delivery, 'complete')).to be false
    end

    it 'only returns true for current step' do
      expect(subject.current?(:confirm, 'confirm')).to be true
    end

    it 'returns false for any further step' do
      expect(subject.current?(:payment, 'address')).to be false
    end
  end

  context 'credit card' do
    let(:card) { build(:credit_card) }

    context '#starred_number' do
      it 'returns stars followed by last 4 digits' do
        expect(subject.starred_number(card)).to eq('** ** ** 4647')
      end
    end

    context '#month_full_year' do
      it 'returns month and 4-digit year' do
        expect(subject.month_full_year(card)).to eq('12/2020')
      end
    end
  end
end
