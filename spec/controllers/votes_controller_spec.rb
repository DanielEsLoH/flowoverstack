require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  # Incluye los helpers de Devise para las pruebas de controlador
  include Devise::Test::ControllerHelpers

  # Crea un usuario, una pregunta y una respuesta para las pruebas
  let(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }
  let(:answer) { Answer.create!(content: 'Some content for the Test', question: question) }

  # Inicia sesión antes de cada prueba
  before do
    sign_in user
  end

  # Prueba para la acción create
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Vote for Question' do
        expect {
          post :create, params: { question_id: question.id }, format: :turbo_stream
        }.to change(Vote, :count).by(1)
      end

      it 'creates a new Vote for Answer' do
        expect {
          post :create, params: { question_id: question.id, answer_id: answer.id }, format: :turbo_stream
        }.to change(Vote, :count).by(1)
      end
    end
  end

  # Prueba para la acción destroy
  describe 'DELETE #destroy' do
    context 'with valid params' do
      it 'destroys the requested Vote for Question' do
        vote = question.votes.create!(user_id: user.id)
        expect {
          delete :destroy, params: { id: vote.id, question_id: question.id }, format: :turbo_stream
        }.to change(Vote, :count).by(-1)
      end

      it 'destroys the requested Vote for Answer' do
        vote = answer.votes.create!(user_id: user.id)
        expect {
          delete :destroy, params: { id: vote.id, question_id: question.id, answer_id: answer.id }, format: :turbo_stream
        }.to change(Vote, :count).by(-1)
      end
    end
  end
end
