class Card < ActiveRecord::Base
  belongs_to :deck
  has_many :card_tags
  has_many :tags, through: :card_tags
end
