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
      transition from: :draft, to: :published, guard: :publishable?, after: :stamp_published_at
    end

    event :unpublish do
      transition from:  :published, to: :draft
    end
  end

  validates :title, presence: true
  validates :content, presence: true

  scope :visible, -> { published.where("published_at <= ?", Time.current).order(published_at: :desc) }

  private

  def publishable?
    title.present? && content.present? && content["blocks"].present?
  end

  def stamp_published_at
    self.published_at ||= Time.current
  end
end
