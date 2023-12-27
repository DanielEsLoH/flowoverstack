# frozen_string_literal: true

class AddUserIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
