class PeopleController < ApplicationController
  def index
    @people =
      if params[:query]
        person_ids = Card.search_by(name: params[:query], organization: params[:query]).pluck(:person_id)
        Person.eager_load(:cards).where(cards: { person_id: person_ids })
      else
        Person.eager_load(:cards)
      end
  end
end
