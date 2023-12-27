# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  # Incluye los helpers de Devise para las pruebas de controlador
  include Devise::Test::ControllerHelpers

  # Crea un usuario y una pregunta para las pruebas
  let(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }

  # Inicia sesión antes de cada prueba
  before do
    sign_in user
  end

  # Prueba para la acción create
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Comment' do
        expect do
          post :create, params: { question_id: question.id, comment: { content: 'Test content' } },
                        format: :turbo_stream
        end.to change(Comment, :count).by(1)
      end

      it 'renders the turbo stream' do
        post :create, params: { question_id: question.id, comment: { content: 'Test content' } }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('turbo-stream action="append" target="flash-messages"')
        expect(response.body).to include('turbo-stream action="replace" target="comments_question"')
      end
    end

    context 'with invalid params' do
      it 'does not create a new Comment' do
        expect do
          post :create, params: { question_id: question.id, comment: { content: nil } }, format: :turbo_stream
        end.not_to change(Comment, :count)
      end
    end
  end
end
