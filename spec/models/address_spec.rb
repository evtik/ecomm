describe Ecomm::Address, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:order) }
  end

  context 'scopes' do
    let!(:billing) { create(:address) }
    let!(:shipping) { create(:address, address_type: 'shipping') }

    context 'billing' do
      it "only returns addresses with address type 'billing'" do
        expect(described_class.billing).to include(billing)
      end

      it " does not return addresses with address type 'shipping'" do
        expect(described_class.billing).not_to include(shipping)
      end
    end

    context 'shipping' do
      it "only returns addresses with address type 'shipping'" do
        expect(described_class.shipping).to include(shipping)
      end

      it " does not return addresses with address type 'billing'" do
        expect(described_class.shipping).not_to include(billing)
      end
    end
  end
end
