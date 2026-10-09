class BlogPost < ApplicationRecord
  include AASM
  extend FriendlyId
  friendly_id :title, use: %i[slugged history]

  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 600, 400 ]
    attachable.variant :hero, resize_to_fit: [ 1600, 800 ]
  end

  aasm column: :status, whiny_persistence: true do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published, guard: :publishable?, after: :stamp_published_at
    end

    event :unpublish do
      transitions from:  :published, to: :draft
    end
  end

  validates :title, presence: true
  validate :content_has_blocks

  scope :visible, -> { published.where("published_at <= ?", Time.current).order(published_at: :desc) }

  def content=(value)
    value = JSON.parse(value) if value.is_a?(String) && value.present?
    super(value)
  rescue JSON::ParserError
    super(nil)
  end

  private

  def content_has_blocks
    errors.add(:content, :blank) unless content.is_a?(Hash) && content['blocks'].present?
  end

  def publishable?
    title.present? && content.present? && content["blocks"].present?
  end

  def stamp_published_at
    self.published_at ||= Time.current
  end
end
