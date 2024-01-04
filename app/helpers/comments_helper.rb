# frozen_string_literal: true

module CommentsHelper
  def comments(answer)
    answer.comments.order(created_at: :desc)
  end
end
