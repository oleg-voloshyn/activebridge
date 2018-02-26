class User < ApplicationRecord
  validates :slack_name, presence: true

  belongs_to :company
  has_many :invoices
  has_many :day_offs
end