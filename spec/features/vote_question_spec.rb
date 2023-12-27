# rubocop:disable all
require 'rails_helper'

RSpec.feature 'Votes', type: :feature, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:question) { Question.create!(title: 'Test title', description: 'Test description', user: user) }

  context 'when user is signed in' do
    before do
      # Inicia sesión antes de cada prueba
      visit new_user_session_path
      fill_in 'Correo electrónico', with: user.email
      fill_in 'Contraseña', with: user.password
      click_button 'Iniciar sesión'
    end

    scenario 'User creates a new vote' do
      visit question_path(question)
      expect(page).to have_css("#votes_question")

      # Encuentra el botón de voto y haz clic en él
      within "#votes_question" do
        find('button').click
      end

      # Verifica que el recuento de votos se haya incrementado
      within "#votes_question" do
        expect(page).to have_content('1')
      end
    end

    scenario 'User deletes a vote' do
      # Crea un voto
      user.votes.create!(votable: question)

      visit question_path(question)
      expect(page).to have_css("#votes_question")

      # Encuentra el botón para eliminar el voto y haz clic en él
      within "#votes_question" do
        find('button').click
      end

      # Verifica que el recuento de votos se haya decrementado
      within "#votes_question" do
        expect(page).to have_content('0')
      end
    end
  end

  context 'when user is not signed in' do
    scenario 'User sees the vote count but cannot vote' do
      visit question_path(question)
      expect(page).to have_css("#votes_question")

      # Verifica que el recuento de votos se muestra pero no hay botón para votar
      within "#votes_question" do
        expect(page).to have_content('0')
        expect(page).not_to have_css('button')
      end
    end
  end
end
