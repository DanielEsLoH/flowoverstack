# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  # Prueba para validar la presencia del atributo content
  it 'validates presence of content' do
    expect(Answer.new(content: nil)).not_to be_valid
  end

  # Prueba para las asociasiones
  it 'belongs to question' do
    assc = described_class.reflect_on_association(:question)
    expect(assc.macro).to eq :belongs_to
  end

  it 'has many comments' do
    assc = described_class.reflect_on_association(:comments)
    expect(assc.macro).to eq :has_many
  end

  it 'has many votes' do
    assc = described_class.reflect_on_association(:votes)
    expect(assc.macro).to eq :has_many
  end
end
