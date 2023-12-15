# spec/models/question_spec.rb
require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) } # Asumiendo que tienes un modelo User

  it 'validates presence of title and description' do
    question = build(:question, user: user, title: nil, description: nil)
    expect(question).not_to be_valid
    expect(question.errors[:title]).to include("can't be blank")
    expect(question.errors[:description]).to include("can't be blank")
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#description_markdown' do
    it 'renders description in markdown' do
      question = create(:question, user: user, description: 'Some **markdown** content')
      expect(question.description_markdown).to include('<strong>markdown</strong> content')
    end
  end
end
