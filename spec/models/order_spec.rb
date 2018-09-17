describe Ecomm::Order, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:shipment) }
    it { is_expected.to belong_to(:coupon) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).class_name('Address') }
    it { is_expected.to have_one(:shipping_address).class_name('Address') }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
  end
end
