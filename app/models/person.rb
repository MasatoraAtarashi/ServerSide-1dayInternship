class Person < ApplicationRecord
  has_many :cards, dependent: :destroy

  # search_by_name
  # カラムが増えていったときに大変。毎回スコープを足していくのは面倒
  # コントローラーの方でif ~ 
  
  scope :named, -> (name) {
    joins(:cards).select('people.*').where('cards.name LIKE ?', "%#{name}%").distinct
  }

  scope :belongsTo, -> (organization_name) {
    joins(:cards).select('people.*').where('cards.organization LIKE ?', "%#{name}%").distinct
  }

  scope :search, -> (query) {
    named(query).or(belongsTo(query)) if query.present?
  }
end
