describe Ecomm::Common::GetOrCreateAddress do
  describe '#call' do
    let(:session) { {} }

    shared_examples 'returns FormObject' do
      example 'returns AddressForm instance' do
        expect(address).to be_instance_of(Ecomm::AddressForm)
      end
    end

    context 'with non-valid address in session' do
      let(:session) do
        {
          address: attributes_for(:address, zip: '27#&*').stringify_keys
        }
      end
      let(:address) { described_class.call(session, 'billing', 1) }

      include_examples 'returns FormObject'

      it 'returns non-valid address previously stored in session' do
        expect(address.zip).to eq('27#&*')
      end
    end

    context 'with existing address' do
      let(:member) { create(:member_with_address) }
      let(:address) { described_class.call(session, 'billing', member.id) }

      include_examples 'returns FormObject'

      it 'populates fields with existing address values' do
        expect(address.country).to eq('Italy')
      end
    end

    context 'with non-existent address' do
      let(:address) { described_class.call(session, 'shipping', 1) }

      include_examples 'returns FormObject'

      it 'returns address with empty fields' do
        expect(address.country).to be_nil
      end
    end
  end
end
