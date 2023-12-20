require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # Incluye los helpers de Devise para las pruebas de controlador
  include Devise::Test::ControllerHelpers

  # Crea un usuario para las pruebas
  let(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  # Inicia sesión antes de cada prueba
  before do
    sign_in user
  end

  # Prueba para la acción index
  describe 'GET #index' do
    it 'assigns all questions as @questions' do
      question = Question.create!(title: 'Test title', description: 'Test description', user: user)
      get :index
      expect(assigns(:questions)).to eq([question])
    end
  end

  # Prueba para la acción show
  describe 'GET #show' do
    it 'assigns the requested question as @question' do
      question = Question.create!(title: 'Test title', description: 'Test description', user: user)
      get :show, params: { id: question.to_param }
      expect(assigns(:question)).to eq(question)
    end
  end

  # Prueba para la acción new
  describe 'GET #new' do
    it 'assigns a new question as @question' do
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  # Prueba para la acción create
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Question' do
        expect {
          post :create, params: { question: { title: 'Test title', description: 'Test description' } }, format: :turbo_stream
        }.to change(Question, :count).by(1)
      end

      it 'assigns a newly created question as @question' do
        post :create, params: { question: { title: 'Test title', description: 'Test description' } }, format: :turbo_stream
        expect(assigns(:question)).to be_a(Question)
        expect(assigns(:question)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved question as @question' do
        post :create, params: { question: { title: nil, description: nil } }, format: :turbo_stream
        expect(assigns(:question)).to be_a_new(Question)
      end
    end
  end
end
