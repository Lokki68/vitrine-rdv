# frozen_string_literal: true

class StatusBadgeComponent < ViewComponent::Base
  def initialize(appointment:)
    @appointment = appointment
  end
end
