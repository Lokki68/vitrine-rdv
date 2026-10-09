module AdminHelper
  STATUS_LABELS = {
    pending_payment: "Paiement en attente",
    confirmed: "Confirmé",
    completed: "Terminé",
    cancelled: "Annulé",
    expired: "Expiré",
    draft: "Brouillon",
    published: "Publié"
  }.freeze

  STATUS_STYLES = {
    "pending_payment" => "badge-warning",
    "confirmed"       => "badge-success",
    "completed"       => "badge-neutral",
    "cancelled"       => "badge-error",
    "expired"         => "badge-ghost",
    "draft"           => "badge-ghost",
    "published"       => "badge-success"
  }.freeze

  def nav_link(label, path)
    link_to label, path, class: ("menu-active" if current_page?(path) || request.path.start_with?(path) && path != admin_root_path)
  end

  def status_badge(status)
    tag.span STATUS_LABELS.fetch(status, status), class: "badge badge-soft #{STATUS_STYLES[status]}"
  end

  def euros(cents)
    number_to_currency(cents.to_i / 100.0, unit: "€", format: "%n %u", separator: ",", delimiter: " ")
  end
end