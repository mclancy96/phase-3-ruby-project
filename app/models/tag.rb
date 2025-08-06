class Tag < ActiveRecord::Base
  has_many :card_tags, dependent: :destroy
  has_many :cards, through: :card_tags
end
