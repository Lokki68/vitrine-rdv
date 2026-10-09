class StripeCheckoutCreatorService
  def initialize(appointment, success_url:, cancel_url:)
    @appointment = appointment
    @success_url = success_url
    @cancel_url = cancel_url
  end

  def call
    session = Stripe::Checkout::Session.create(
      mode: "payment",
      customer_email: @appointment.client_email,
      line_items: [{
                     quantity: 1,
                     price_data: {
                       currency: @appointment.service.currency,
                       unit_amount: @appointment.service.deposit_cents,
                       product_data: {
                         name: "Acompte - #{@appointment.service.name}",
                         description: I18n.l(@appointment.starts_at, format: :long)
                       }
                     }
                   }],
      metadata: { appointment_id: @appointment.id },
      payment_intent_data: { metadata: { appointment_id: @appointment.id } },
      expires_at: (Appointment::PENDING_TTL + 1.minutes).from_now.to_i,
      success_ur: "#{@success_url}?session_id#{CHECKOUT_SESSION_ID}",
      cancel_url: @cancel_url,
    )

    @appointment.update!(stripe_checkout_session_id: session.id)
    session.url
  end
end