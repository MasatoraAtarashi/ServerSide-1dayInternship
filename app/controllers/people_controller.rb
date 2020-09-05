class PeopleController < ApplicationController
  def index
    @people = Person.search(params[:query])
  end
end
