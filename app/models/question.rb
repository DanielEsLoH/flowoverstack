class Question < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    belongs_to :user
    has_many :comments, as: :commentable, dependent: :destroy
end
