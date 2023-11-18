class CommentsController < ApplicationController
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @question = Question.find params[:question_id]

    respond_to do |format|
      if @comment.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('comments_all', partial: 'comments/comments', 
                                                                                locals: { comments: @commentable.comments })}
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
