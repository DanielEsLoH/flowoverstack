# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  content     :text
#  question_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Answer < ApplicationRecord
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  validates :content, presence: true
end
