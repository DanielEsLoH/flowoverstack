# frozen_string_literal: true

module VotesHelper
  def vote_by_user(answer)
    current_user.votes.find_by(votable: answer)
  end
end
