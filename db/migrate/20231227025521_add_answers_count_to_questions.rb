# frozen_string_literal: true

class AddAnswersCountToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :answers_count, :integer, default: 0
  end
end
