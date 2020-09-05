class Card < ApplicationRecord
  include CalculationTitleScore
  belongs_to :person

  def merge
    self.person_id = get_correct_person_id(self)
  end

  def get_correct_person_id(card)
    person_id = card.person_id
    candidate_card = Card.find_by(email: card.email)
    if candidate_card
      person_id = candidate_card.person_id if is_mergable(card, candidate_card)
    end
    return person_id
  end

  def self.search_by(name:, organization:)
    self.where('name LIKE ? OR organization LIKE ?', "%#{name}%", "%#{organization}%")
  end

  private

  def is_mergable(card1, card2)
    if card1.name.gsub(/\s/, "") == card2.name.gsub(/\s/, "") || calculation(card1.title, card2.title) >= 80
      true
    else
      false
    end
  end
end
