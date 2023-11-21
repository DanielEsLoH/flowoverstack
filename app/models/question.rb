class Question < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  # def formatted_content
  #   Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(truncated_description).html_safe
  #   # Aplicar el formato Markdown al contenido acortado y convertirlo en HTML seguro para mostrarlo en la vista
  # end

  def description_markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, fenced_code_blocks: true, lax_html_blocks: true)
    markdown.render(description).html_safe
  end
end
