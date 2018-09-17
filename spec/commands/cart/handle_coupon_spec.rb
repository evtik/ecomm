describe Ecomm::Cart::HandleCoupon do
  describe '#call' do
    error_message = 'Some weird error!'
    let(:error) { error_message }
    let(:command) do
      described_class.new(double('GetCouponError', call: error_message))
    end

    context 'with invalid inputs' do
      shared_examples 'returns error message' do
        example 'it returns error message' do
          expect { command.call('123456') }.to publish(:error, error)
        end
      end

      context 'non-existent coupon code' do
        include_examples 'returns error message'
      end

      context 'expired coupon code' do
        before { create(:coupon, expires: Date.today - 1.day) }
        include_examples 'returns error message'
      end

      context 'coupon been already taken' do
        before do
          coupon = build(:coupon)
          create(:order, coupon: coupon)
          coupon.save
        end

        include_examples 'returns error message'
      end
    end

    context 'with valid input' do
      it 'returns coupon instance' do
        coupon = create(:coupon)
        expect { command.call('123456') }.to publish(:ok, coupon)
      end
    end
  end
end
