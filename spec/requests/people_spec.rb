require "rails_helper"
include Capybara::RSpecMatchers

RSpec.describe PeopleController, type: :request do
  let(:person) { create(:person) }
  let!(:card) { person.cards.create }


  describe "GET /" do

    it 'show valid cards' do
      get people_path
      expect(response.status).to eq 200
      expect(response.body).to have_css 'img'
    end
  end
end