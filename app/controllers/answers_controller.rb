class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answers = @question.answers

    respond_to do |format|
      if @answer.save
        @votes = @answer.votes
        flash[:notice] = "¡Respuesta recibida!"
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications', locals: {message: flash[:notice]}) +
                              turbo_stream.replace("answers_all", partial: 'answers/answers_all', locals: {answers: @answers})
        end
      else
        flash[:alert] = "Error al crear la respuesta"
        format.turbo_stream { render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications', locals: {message: flash[:alert]})}
        format.html { redirect_to question_path(@question) }
      end
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:content)
    end
end
