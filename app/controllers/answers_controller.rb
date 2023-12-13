class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answers = @question.answers

    if @answer.save
      @votes = @answer.votes
      flash[:success] = "Respuesta creada con exito"
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("answers_all", partial: 'answers/answers_all', locals: {answers: @answers}) }
      end
    else
      flash[:error] = "Error al crear la respuesta"
      redirect_to question_path(@answer)
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:content)
    end
end
