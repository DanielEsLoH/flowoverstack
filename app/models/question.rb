# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
class Question < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  def description_markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, fenced_code_blocks: true, lax_html_blocks: true)
    markdown.render(description).html_safe
  end
end
