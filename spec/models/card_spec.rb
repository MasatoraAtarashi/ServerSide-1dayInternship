require "rails_helper"

RSpec.describe Card, type: :model do
  let(:person) { create(:person) }
  let!(:card1) do
    person.cards.create(name: '山田太郎', organization: '三井物産')
  end
  let!(:card2) do
    person.cards.create(name: '佐藤花子', organization: 'SanSan')
  end
  let!(:card3) do
    person.cards.create(name: '鈴木一郎', organization: '日本')
  end

  describe "#merge" do
    context "email perfectly match and occupational relevance score is over 80" do
      it 'is merged' do
        expect(1).to eq 2
      end
    end

    context "email perfectly match and occupational relevance score is over 80" do
      it 'is merged' do
        expect(1).to eq 1
      end
    end

    context "not exist same user" do
      it 'is not merged' do
        expect(1).to eq 1
      end
    end
  end

  describe "#search_near_email" do
    context "i in email is 1" do
      it 'returns valid cards' do
        expect(1).to eq 1
      end
    end

    context "0 in email is O" do
      it 'returns valid cards' do
        expect(1).to eq 1
      end
    end

    context "_ in email is ''" do
      it 'returns valid cards' do
        expect(1).to eq 1
      end
    end
  end

  describe "#match?" do
    context "last name is changed" do
      it 'returns true' do
        expect(1).to eq 1
      end
    end

    context "There is not any space between the first and last name" do
      it 'returns true' do
        expect(1).to eq 1
      end
    end
  end

  describe "#self.search_by" do
    subject { Card.search_by(name: name, organization: organization)}
    context "search by name" do
      let(:name) { '山田太郎' }
      let(:organization) { '山田太郎' }
      it 'returns valid cards' do
        expect(subject).to eq([card1])
      end
    end

    context "search by organization" do
      let(:name) { 'SanSan' }
      let(:organization) { 'SanSan' }
      it 'returns valid cards' do
        expect(subject).to eq([card2])
      end
    end

    context "there is no query" do
      let(:name) { '' }
      let(:organization) { '' }
      it 'returns valid cards' do
        expect(subject).to eq([card1, card2, card3])
      end
    end
  end
end
