# frozen_string_literal: true

namespace :db do
  desc 'Create 50 questions'
  task create_questions: :environment do
    500.times do |i|
      Question.create!(
        title: "Pregunta #{i + 1}",
        description: "Descripción de la pregunta #{i + 1}",
        user_id: 1 # Asegúrate de que este usuario exista en tu base de datos
      )
    end
  end
end
