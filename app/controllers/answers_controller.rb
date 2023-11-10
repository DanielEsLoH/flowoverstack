class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      flash[:success] = "Respuesta creada con exito"
      redirect_to question_path(@question)
    else
      flash[:error] = "Error al crear la respuesta"
      redirect_to question_path(@question)
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:content)
    end
end
