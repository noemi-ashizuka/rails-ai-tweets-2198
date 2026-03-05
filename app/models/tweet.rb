class Tweet < ApplicationRecord
  has_one_attached :photo
  validates :long, presence: true

  after_create_commit :enqueue_image_generation, unless: :photo_attached?

  def enqueue_image_generation
    GenerateImageJob.perform_later(self)
  end

  def photo_attached?
    photo.attached?
  end
end
