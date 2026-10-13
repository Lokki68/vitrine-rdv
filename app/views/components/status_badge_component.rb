# frozen_string_literal: true

class StatusBadgeComponent < ViewComponent::Base
  def initialize(appointment:)
    @status_label = BADGE_LABEL[appointment.status]
    @status_class = BADGE[appointment.status]
  end

  private

  BADGE = {
    "confirmed" => "badge-success",
    "pending_payment" => "badge-warning",
    "cancelled" => "badge-error",
    "expired" => "badge-ghost",
  }

  BADGE_LABEL = {
    "confirmed" => "Confirmé",
    "pending_payment" => "En attente de paiement",
    "cancelled" => "Annulé",
    "expired" => "Expiré",
  }
end
