class CommentsController < ApplicationController
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @question = Question.find params[:question_id]
    @answer = Answer.find(params[:answer_id]) if params[:answer_id].present?

    respond_to do |format|
      if @comment.save
          if @comment.commentable_type == "Question"
            format.turbo_stream { render turbo_stream: turbo_stream.replace('comments_question', partial: 'comments/comments_question',
                                                                                locals: { comments: @commentable.comments })}
          elsif @comment.commentable_type == "Answer"
            format.turbo_stream { render turbo_stream: turbo_stream.replace("comments_answer_#{@answer.id}", partial: 'comments/comments_answers',
                                                                                locals: { answer: @answer, comments: @commentable.comments })}
          end
      else
        redirect_to question_path(@commentable), alert: 'Error: Comment could not be created.'
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
