describe Ecomm::AddressForm, type: :form do
  context 'first name' do
    include_examples 'name', :first_name
  end

  context 'last name' do
    include_examples 'name', :last_name
  end

  context 'street_address' do
    it { is_expected.to validate_presence_of(:street_address) }
    it { is_expected.to allow_value('221B Baker Street').for(:street_address) }
    it { is_expected.to allow_value('Героїв Крут 11').for(:street_address) }
    it { is_expected.to allow_value('7, Bayparkway 20').for(:street_address) }
    it { is_expected.not_to allow_value('7, |nvalid St').for(:street_address) }
    it { is_expected.not_to allow_value('7' * 31).for(:street_address) }
  end

  context 'city' do
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to allow_value('Trowbridge').for(:city) }
    it { is_expected.to allow_value('Київ').for(:city) }
    it { is_expected.to allow_value('Los Angeles').for(:city) }
    it { is_expected.not_to allow_value('City 20').for(:city) }
    it { is_expected.not_to allow_value('C|ty').for(:city) }
    it { is_expected.not_to allow_value('a' * 31).for(:city) }
  end

  context 'zip' do
    it { is_expected.to validate_presence_of(:zip) }
    it { is_expected.to allow_value('12345').for(:zip) }
    it { is_expected.to allow_value('12345-6789').for(:zip) }
    it { is_expected.not_to allow_value('12345-67891').for(:zip) }
    it { is_expected.not_to allow_value('12').for(:zip) }
    it { is_expected.not_to allow_value('a1234').for(:zip) }
    it { is_expected.not_to allow_value('abcdef').for(:zip) }
  end

  context 'country' do
    it { is_expected.to validate_presence_of(:country) }
  end

  context 'phone' do
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to allow_value('+12345').for(:phone) }
    it { is_expected.to allow_value('+123456789101112').for(:phone) }
    it { is_expected.not_to allow_value('12345').for(:phone) }
    it { is_expected.not_to allow_value('+123').for(:phone) }
    it { is_expected.not_to allow_value('+1234567891011123').for(:phone) }
    it { is_expected.not_to allow_value('+abcdef').for(:phone) }
  end
end
