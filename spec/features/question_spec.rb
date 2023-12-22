require 'rails_helper'

RSpec.feature "Questions", type: :feature, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }

  before do
    # Inicia sesión antes de cada prueba
    visit new_user_session_path
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_button 'Iniciar sesión'
  end

  scenario 'User creates a new question' do
    visit questions_path
    click_link 'Hacer una pregunta'  # Abre el modal

    within '#modal' do  # Asegúrate de reemplazar 'new_question_frame' con el ID correcto de tu Turbo Frame
      fill_in 'Titulo', with: 'Test title'
      fill_in 'Descripción', with: 'Test description'
      click_button 'Crear pregunta'
    end

    expect(page).to have_content('Pregunta creada correctamente')
    expect(page).to have_content('Test title')

    # Visita la página de la pregunta
    visit question_path(Question.last)

    # Verifica que el título y la descripción de la pregunta están presentes en la página
    expect(page).to have_content('Test title')
    expect(page).to have_content('Test description')
  end
end
