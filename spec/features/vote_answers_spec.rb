# rubocop:disable all
require 'rails_helper'

RSpec.feature 'Votes', type: :feature, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }
  let(:answer) { question.answers.last }

  context 'when user is signed in' do
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

    scenario 'User creates a new vote for an answer' do
      visit question_path(question)
      expect(page).to have_css("#votes_#{dom_id(answer)}")

      # Encuentra el botón de voto y haz clic en él
      within "#votes_#{dom_id(answer)}" do
        find('button').click
      end

      # Verifica que el recuento de votos se haya incrementado
      within "#votes_#{dom_id(answer)}" do
        expect(page).to have_content('1')
      end
    end

    scenario 'User deletes a vote for an answer' do
      # Crea un voto
      user.votes.create!(votable: answer)

      visit question_path(question)
      expect(page).to have_css("#votes_#{dom_id(answer)}")

      # Encuentra el botón para eliminar el voto y haz clic en él
      within "#votes_#{dom_id(answer)}" do
        find('button').click
      end

      # Verifica que el recuento de votos se haya decrementado
      within "#votes_#{dom_id(answer)}" do
        expect(page).to have_content('0')
      end
    end
  end
end
