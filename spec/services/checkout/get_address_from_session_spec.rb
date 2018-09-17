describe Ecomm::Checkout::GetAddressFromSession do
  describe '#call' do
    let(:session) { { address: attributes_for(:address, country: 'Z|mbabwe') } }
    subject { described_class.call(session) }

    it 'returns AddressForm instance' do
      is_expected.to be_instance_of(Ecomm::AddressForm)
    end

    it 'populates address fields' do
      expect(subject.country).to eq('Z|mbabwe')
    end

    it 'ensures returned address to have been validated' do
      expect_any_instance_of(Ecomm::AddressForm).to receive(:valid?)
      described_class.call(session)
    end

    it 'clears session saved address' do
      described_class.call(session)
      expect(session[:address]).to be_nil
    end
  end
end
