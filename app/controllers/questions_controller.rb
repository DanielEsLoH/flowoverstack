class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end
  
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    respond_to do |format|
      if @question.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('questions_all', partial: 'questions/questions', locals: {questions: Question.all}) }
      end
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :description)
    end
  
end
