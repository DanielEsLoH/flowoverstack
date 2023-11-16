class CommentsController < ApplicationController
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @question = Question.find params[:question_id]


    if @comment.save
      redirect_to question_path(@question), notice: 'Comment was successfully created.'
    else
      redirect_to question_path(@question), alert: 'Error: Comment could not be created.'
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
