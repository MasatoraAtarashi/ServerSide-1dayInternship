class Card < ApplicationRecord
  include CalculationTitleScore
  belongs_to :person

  def merge
    self.person_id = get_correct_person_id(self)
  end

  def get_correct_person_id(card)
    person_id = card.person_id
    candidate_cards = search_near_email(card.email)
    candidate_cards.each do |candidate_card|
      person_id = candidate_card.person_id if mergable?(card, candidate_card)
    end
    return person_id
  end

  def self.search_by(name:, organization:)
    self.where('name LIKE ? OR organization LIKE ?', "%#{name}%", "%#{organization}%")
  end

  private

  def search_near_email(email)
    cards = []
    Card.all.each do |card|
      if flatten(card.email) == flatten(email)
        cards << card
      end
    end
    cards
  end

  def flatten(word)
    word.gsub(/1|O|_/, '1' => 'i', 'O' => '0', '_' => '')
  end

  def mergable?(card1, card2)
    if match?(name1: card1.name, name2: card2.name) || calculation(card1.title, card2.title) >= 80
      true
    else
      false
    end
  end

  def match?(name1:, name2:)
    is_match = false
    if name1.gsub(/\s/, '') == name2.gsub(/\s/, '')
      is_match = true
    elsif name1.gsub(/\W+\s/, '') == name2.gsub(/\W+\s/, '')
      is_match = true
    end
    is_match
  end
end
