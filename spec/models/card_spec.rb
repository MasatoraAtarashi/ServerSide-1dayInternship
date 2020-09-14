require "rails_helper"

RSpec.describe Card, type: :model do
  let(:person) { create(:person) }
  let(:person2) { create(:person) }
  let(:card) { person.cards.create }

  describe "#merge" do
    let!(:card1) do
      person.cards.create(email: email, name: name, title: title)
    end
    let!(:card2) do
      person2.cards.create(email: email2, name: name2, title: title2)
    end
    let(:email) { 'yamada@example.com' }
    let(:email2) { 'yamada@example.com' }
    let(:name) { '山田 太郎' }
    let(:name2) { '佐藤 花子' }
    let(:title) { 'フロントエンドエンジニア' }
    let(:title2) { 'サーバーサイドエンジニア' }
    subject { card1.merge }
    context "email perfectly match and occupational relevance score is over 80" do
      it 'is merged' do
        subject
        expect(card1.person_id).to eq card2.person_id
      end
    end

    context "email perfectly match and occupational relevance score is over 80" do
      let(:name) { '山田 太郎' }
      let(:name2) { '山田 太郎' }
      let(:title2) { '人事' }
      it 'is merged' do
        subject
        expect(card1.person_id).to eq card2.person_id
      end
    end

    context "not exist same user" do
      let(:email) { 'yamada@example.com' }
      let(:email2) { 'another@example.com' }
      it 'is not merged' do
        subject
        expect(card1.person_id).to_not eq card2.person_id
      end
    end
  end

  describe "#search_near_email" do
    let!(:card1) do
      person.cards.create(email: email)
    end
    let(:email) { 'i@example.com' }
    subject { card1.send(:search_near_email, query_email) }
    context "i in email is 1" do
      let(:query_email) { '1@example.com' }
      it 'returns valid cards' do
        expect(subject).to eq([card1])
      end
    end

    context "0 in email is O" do
      let(:email) { '0@example.com' }
      let(:query_email) { 'O@example.com' }
      it 'returns valid cards' do
        expect(subject).to eq([card1])
      end
    end

    context "_ in email is ''" do
      let(:email) { 'a_a@example.com' }
      let(:query_email) { 'aa@example.com' }
      it 'returns valid cards' do
        expect(subject).to eq([card1])
      end
    end
  end

  describe "#match?" do
    subject { card.send(:match?, name1: name1, name2: name2) }
    context "last name is changed" do
      let(:name1) { '山田 太郎' }
      let(:name2) { '田中 太郎' }
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context "There is not any space between the first and last name" do
      let(:name1) { '山田太郎' }
      let(:name2) { '山田 太郎' }
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe "#self.search_by" do
    let!(:card1) do
      person.cards.create(name: '山田 太郎', organization: '三井物産')
    end
    let!(:card2) do
      person.cards.create(name: '佐藤 花子', organization: 'SanSan')
    end
    let!(:card3) do
      person.cards.create(name: '鈴木 一郎', organization: '日本')
    end

    subject { Card.search_by(name: name, organization: organization)}

    context "search by name" do
      let(:name) { '山田 太郎' }
      let(:organization) { '山田 太郎' }
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
