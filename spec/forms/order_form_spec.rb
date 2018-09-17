describe Ecomm::OrderForm, type: :form do
  describe '#addresses_valid?' do
    context 'with use_billing set to true' do
      it 'returns true if both billing and shipping addresses are valid' do
        order = described_class.new(
          use_billing: true,
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping')
        )
        expect(order.addresses_valid?).to be true
      end

      it 'returns true if billing is valid and shipping is invalid' do
        order = described_class.new(
          use_billing: true,
          billing: attributes_for(:address),
          shipping: attributes_for(:address, city: '', address_type: 'shipping')
        )
        expect(order.addresses_valid?).to be true
      end
    end

    context 'with use_billing set to false' do
      it 'returns true if both billing and shipping addresses are valid' do
        order = described_class.new(
          use_billing: false,
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping')
        )
        expect(order.addresses_valid?).to be true
      end

      it 'returns true if billing is valid and shipping is invalid' do
        order = described_class.new(
          use_billing: false,
          billing: attributes_for(:address),
          shipping: attributes_for(:address, zip: '', address_type: 'shipping')
        )
        expect(order.addresses_valid?).to be false
      end

      it 'returns true if billing is invalid and shipping is valid' do
        order = described_class.new(
          use_billing: false,
          billing: attributes_for(:address, phone: '*#@!'),
          shipping: attributes_for(:address, address_type: 'shipping')
        )
        expect(order.addresses_valid?).to be false
      end
    end
  end
end
