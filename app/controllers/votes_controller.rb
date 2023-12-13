class VotesController < ApplicationController
  before_action :set_question, only: [:create, :destroy]
  before_action :set_votable, only: [:create, :destroy]
  def create
    @vote = @votable.votes.create(user_id: current_user.id)
    votable_type = @votable.class.name
    respond_to do |format|
      if votable_type == "Question"
        format.turbo_stream { render turbo_stream: turbo_stream.replace("votes_question", partial: 'votes/votes_question', locals: {question: @question })}
      elsif votable_type == "Answer"
        set_answer
        format.turbo_stream { render turbo_stream: turbo_stream.replace("votes_answer_#{@answer.id}", partial: 'votes/votes_answers', locals: {question: @question, answer: @answer})}
      end
    end
  end

  def destroy
    votable_type = @votable.class.name
    @votable.votes.where(user_id: current_user.id).destroy_all
    respond_to do |format|
      if votable_type == 'Question'
        format.turbo_stream { render turbo_stream: turbo_stream.replace("votes_question", partial: 'votes/votes_question', locals: {question: @question })}
      elsif votable_type == 'Answer'
        set_answer
        format.turbo_stream { render turbo_stream: turbo_stream.replace("votes_answer_#{@answer.id}", partial: 'votes/votes_answers', locals: {question: @question, answer: @answer})}
      else
      end
    end
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    end

    def set_answer
      @answer = Answer.find(params[:answer_id])
    end

    def set_votable
      @votable = find_votable
    end

    def votes_params
      params.require(:vote)
    end

    def find_votable
      @votable = if params[:answer_id].present?
        Answer.find params[:answer_id]
      else
        Question.find params[:question_id]
      end
    end
end
