# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  # Prueba para las asociaciones
  it 'belongs to user' do
    assc = described_class.reflect_on_association(:user)
    expect(assc.macro).to eq :belongs_to
  end

  it 'belongs to votable' do
    assc = described_class.reflect_on_association(:votable)
    expect(assc.macro).to eq :belongs_to
  end

  # Prueba para validar la unicidad del usuario en el ámbito de votable_id y votable_type
  it 'validates uniqueness of user in the scope of votable_id and votable_type' do
    user = User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    question = Question.create!(title: 'Some title test', description: 'Some description test', user: user)
    votable = Answer.create!(content: 'Some content', question: question, user: user)
    Vote.create!(user: user, votable: votable)
    vote2 = Vote.new(user: user, votable: votable)
    expect(vote2).not_to be_valid
  end
end
