# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Answers', type: :feature, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }

  before do
    # Inicia sesión antes de cada prueba
    visit new_user_session_path
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_button 'Iniciar sesión'
  end

  scenario 'User creates a new answer' do
    visit question_path(question)

    # llena el formulario de respuesta y lo envía
    fill_in 'Agrega una respuesta', with: 'Some answer for test'
    click_button 'Enviar Respuesta'

    # verifica el toast y la respuesta creada
    expect(page).to have_content('¡Respuesta recibida!')
    expect(page).to have_content('Some answer for test')
  end
end
