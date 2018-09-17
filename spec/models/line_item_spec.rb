describe Ecomm::LineItem, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end
end
