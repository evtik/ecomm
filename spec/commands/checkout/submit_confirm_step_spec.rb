describe Ecomm::Checkout::SubmitConfirmStep, type: :command do
  describe '#call' do
    let(:order) { build(:order, customer: build(:member)) }

    let(:session) do
      { cart: 'cart', order: 'order', discount: 1, coupon_id: 2 }
    end

    let(:mailer) { spy('OrderMailer') }
    let(:flash) { {} }
    let(:args) { [session, {}, flash, 1] }

    let(:command) do
      described_class.new(double('BuildCompletedOrder', call: order), mailer)
    end

    context 'with successful order placement' do
      before do |example|
        command.call(*args) unless example.metadata[:skip_before]
      end

      it 'clears order related session keys' do
        %i(cart order discount coupon_id).each do |key|
          expect(session[key]).to be_nil
        end
      end

      it 'sends order confirmation email' do
        expect(mailer).to have_received(:order_email)
      end

      it 'sets flash order confirmed key to true' do
        expect(flash[:order_confirmed]).to be true
      end

      it 'creates new order in db', skip_before: true do
        expect { command.call(*args) }.to change(Ecomm::Order, :count).by(1)
      end

      it 'logs error message if sending order email fails', skip_before: true do
        allow(mailer).to(
          receive_message_chain(:order_email, :deliver).and_raise(StandardError,
                                                                  'email error')
        )
        expect(Rails.logger).to receive(:error).with(/email error/)
        command.call(*args)
      end

      it('publishes :ok event and redirects to show complete step',
         skip_before: true) do
        expect { command.call(*args) }.to publish(:ok, checkout_complete_path)
      end
    end

    context 'with failed order placement' do
      before { allow(order).to receive(:save).and_return(false) }

      it 'sets flash alert to failure message' do
        command.call(*args)
        expect(flash[:alert]).to eq(
          I18n.t('ecomm.checkout.submit_confirm.order_placement_error')
        )
      end

      it 'publishes :error event and redirects to show confirm step' do
        expect { command.call(*args) }.to publish(:error, checkout_confirm_path)
      end
    end
  end
end
