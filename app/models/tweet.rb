class Tweet < ApplicationRecord
  validates :long, presence: true
end
