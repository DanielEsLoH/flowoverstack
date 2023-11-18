class VotesController < ApplicationController
  before_action :set_question, only: [:create, :destroy]
  before_action :set_votable, only: [:create, :destroy]
  def create
    @vote = @votable.votes.create(user_id: current_user.id)

    if @vote.save
      redirect_to question_path(@votable), notice: 'Vote add'
    else
      redirect_to question_path(@votable), alert: "Error al registrar el voto"
    end
  end

  def destroy
    @votable.votes.where(user_id: current_user.id).destroy_all
    redirect_to question_path(@votable), notice: 'voto deshecho exitosamente'
  end

  private
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