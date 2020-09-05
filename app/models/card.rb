class Card < ApplicationRecord
  include CalculationTitleScore
  belongs_to :person

  def merge
    self.person_id = search_same_person_id(self)
  end

  def search_same_person_id(card)
    candidate_cards = Card.where(email: card.email)
    candidate_cards.each do |candidate_card|
      if card.name.gsub(" ", "") == candidate_card.name.gsub(" ", "") || calculation(card.title, candidate_card.title) >= 80
        return candidate_card.person_id
      end
    end
    return card.person_id
  end

  def self.search_by(name:, organization:)
    self.where('name LIKE ? OR organization LIKE ?', "%#{name}%", "%#{organization}%")
  end
end
