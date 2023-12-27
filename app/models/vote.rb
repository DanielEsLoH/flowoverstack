# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  votable_type :string           not null
#  votable_id   :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true
  validates_uniqueness_of :user_id, scope: %i[votable_id votable_type]
end
