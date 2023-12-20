require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
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
      it 'creates a new Answer' do
        expect {
          post :create, params: { question_id: question.id, answer: { content: 'Test content' } }, format: :turbo_stream
        }.to change(Answer, :count).by(1)
      end

      it 'renders the turbo stream' do
        post :create, params: { question_id: question.id, answer: { content: 'Test content' } }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('turbo-stream action="append" target="flash-messages"')
        expect(response.body).to include('turbo-stream action="replace" target="answers_all"')
      end
    end

    context 'with invalid params' do
      it 'does not create a new Answer' do
        expect {
          post :create, params: { question_id: question.id, answer: { content: nil } }, format: :turbo_stream
        }.not_to change(Answer, :count)
      end
    end
  end
end
