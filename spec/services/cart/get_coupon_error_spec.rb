describe Ecomm::Cart::GetCouponError do
  describe '.call' do
    it "returns 'does not exist' message" do
      result = described_class.call([false])
      expect(result).to eq(t('ecomm.coupon.non_existent'))
    end

    it "returns 'taken' message" do
      result = described_class.call([true, false])
      expect(result).to eq(t('ecomm.coupon.taken'))
    end

    it "returns 'expired' message" do
      result = described_class.call([true, true, false])
      expect(result).to eq(t('ecomm.coupon.expired'))
    end
  end
end
