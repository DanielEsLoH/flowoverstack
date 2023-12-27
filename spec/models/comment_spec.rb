# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Prueba para validar la presencia del atributo content
  it 'Validates presence of content' do
    expect(Comment.new(commentable: nil)).not_to be_valid
  end

  # Prueba para las asociaciones
  it 'belongs to commentable' do
    assc = described_class.reflect_on_association(:commentable)
    expect(assc.macro).to eq :belongs_to
  end
end
