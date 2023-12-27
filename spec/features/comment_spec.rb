# frozen_string_literal: true
# rubocop:disable all

require 'rails_helper'

RSpec.feature 'Comments', type: :feature, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }
  let(:answer) { question.answers.last }

  before do
    # Inicia sesión antes de cada prueba
    visit new_user_session_path
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_button 'Iniciar sesión'

    # Selecciona la respuesta específica
    visit question_path(question)
    # Llena el formulario de comentario para la respuesta
    fill_in 'Agrega una respuesta', with: 'Some answer for test'
    click_button 'Enviar Respuesta'
  end

  scenario 'User creates a new comment for one question' do
    visit question_path(question)

    within "#commentable_#{question.id}_question" do
      fill_in 'Agrega un comentario', with: 'Some comment for question'
      click_button 'Comentar'
    end

    # verifica el toast y el comentario creado
    expect(page).to have_content('Comentario creado')
    expect(page).to have_content('Some comment for question')
  end

  scenario 'User creates a new comment for one answer' do
    visit question_path(question)

    # llena el formulario de la respuesta específica
    within "#commentable_#{answer.id}_answer" do
      fill_in 'Agrega un comentario', with: 'Some comment for answer'
      click_button 'Comentar'
    end

    # verifica el toast y el comentario creado
    expect(page).to have_content('Comentario creado')
    expect(page).to have_content('Some comment for answer')
  end
end
