class VotesController < ApplicationController
  before_action :set_question, only: [:create, :destroy]
  before_action :set_votable, only: [:create, :destroy]
  before_action :user_vote, only: [:create]
  def create
    @vote = @votable.votes.create(user_id: current_user.id)
    respond_to do |format|
      if @vote.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace("votes", partial: 'votes/votes', locals: {})}
        # redirect_to question_path(@votable), alert: "Error al registrar el voto"
      else
        redirect_to question_path(@user_vote), notice: 'Vote add'
      end
    end
  end

  def destroy
    @votable.votes.where(user_id: current_user.id).destroy_all
    redirect_to question_path(@votable), notice: 'voto deshecho exitosamente'
  end

  private
    def user_vote
      @user_vote = Vote.find_by(user_id: current_user.id)
    end

    def set_question
      @question = Question.find(params[:question_id])
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
