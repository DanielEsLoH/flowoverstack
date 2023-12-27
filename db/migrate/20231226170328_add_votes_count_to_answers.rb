# frozen_string_literal: true

class AddVotesCountToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :votes_count, :integer, default: 0
  end
end
