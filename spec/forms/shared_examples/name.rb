shared_examples 'name' do |attribute|
  it { is_expected.to validate_presence_of(attribute) }
  it { is_expected.to allow_value('Coolige').for(attribute) }
  it { is_expected.to allow_value('Calvin Coolige').for(attribute) }
  it { is_expected.to allow_value('O`Hara').for(attribute) }
  it { is_expected.to allow_value('John-Patrick').for(attribute) }
  it { is_expected.to allow_value('Нелупибатько').for(attribute) }
  it { is_expected.to allow_value('Ґут-Кульчицький').for(attribute) }
  it { is_expected.not_to allow_value("O'Hara").for(attribute) }
  it { is_expected.not_to allow_value('Петренк0').for(attribute) }
  it { is_expected.not_to allow_value('Д№аниленко').for(attribute) }
  it { is_expected.not_to allow_value('h' * 31).for(attribute) }
end
