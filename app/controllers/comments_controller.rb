# frozen_string_literal: true
# rubocop:disable all

class CommentsController < ApplicationController
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @question = Question.find params[:question_id]
    @answer = Answer.find(params[:answer_id]) if params[:answer_id].present?

    respond_to do |format|
      if @comment.save
        flash.now[:notice] = 'Comentario creado'
        commentable_type = @comment.commentable_type
        comments = @commentable.comments.order(created_at: :desc)
        if commentable_type == 'Question'
          format.turbo_stream do
            render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                       locals: { message: flash[:notice] }) +
                                 turbo_stream.replace('comments_question', partial: 'comments/comments_question',
                                                                           locals: { comments: comments })
          end
        elsif commentable_type == 'Answer'
          format.turbo_stream do
            render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                       locals: { message: flash[:notice] }) +
                                 turbo_stream.replace("comments_answer_#{@answer.id}",
                                                      partial: 'comments/comments_answers', locals: { answer: @answer, comments: @commentable.comments })
          end
        end
      else
        flash.now[:alert] = 'No se ha creado ningún comentario'
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                     locals: { message: flash[:alert] })
        end
        format.html { redirect_to question_path(@question) }
      end
    end
  end

  private

  def find_commentable
    @commetable = if params[:answer_id].present?
                    Answer.find params[:answer_id]
                  else
                    Question.find params[:question_id]
                  end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
