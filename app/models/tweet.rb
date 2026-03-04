class Tweet < ApplicationRecord
  has_one_attached :photo
  validates :long, presence: true
end
