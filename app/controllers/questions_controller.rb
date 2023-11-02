class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @questions = Question.all
  end
   
  def show
    @comments = @question.comments.order(created_at: :desc)
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    respond_to do |format|
      if @question.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('questions_all', partial: 'questions/questions', locals: {questions: Question.all}) }
      end
    end
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :description)
    end
  
end
