# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect(Question.new(title: 'Test title')).not_to be_valid
  end

  it 'validates presence of description' do
    expect(Question.new(description: 'Test description')).not_to be_valid
  end

  it 'belongs_to user' do
    assc = described_class.reflect_on_association(:user)
    expect(assc.macro).to eq :belongs_to
  end

  it 'has many comments' do
    assc = described_class.reflect_on_association(:comments)
    expect(assc.macro).to eq :has_many
  end

  it 'has many answers' do
    assc = described_class.reflect_on_association(:answers)
    expect(assc.macro).to eq :has_many
  end

  it 'has many votes' do
    assc = described_class.reflect_on_association(:votes)
    expect(assc.macro).to eq :has_many
  end

  # Prueba para el método description_markdown
  it 'renders description as markdown' do
    question = Question.new(title: 'Test title', description: '# Test description')
    expect(question.description_markdown).to eq "<h1>Test description</h1>\n"
  end
end
