class Person < ApplicationRecord
  has_many :cards, dependent: :destroy

  scope :named, -> (name) {
    joins(:cards).select('people.*').where('cards.name LIKE ?', "%#{name}%").distinct
  }

  scope :belongs_to, -> (organization_name) {
    joins(:cards).select('people.*').where('cards.organization LIKE ?', "%#{name}%").distinct
  }

  scope :search, -> (query) {
    named(query).or(belongs_to(query)) if query.present?
  }
end
