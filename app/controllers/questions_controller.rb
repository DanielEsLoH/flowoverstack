# frozen_string_literal: true
# rubocop:disable all

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]
  before_action :authenticate_user!, only: %i[new create]
  def index
    if params[:search]
      @pagy, @questions = pagy_countless(Question.includes(:user).where('title LIKE ?', "%#{params[:search]}%").order(created_at: :desc))
    else
      @pagy, @questions = pagy_countless(Question.includes(:user).order(created_at: :desc))
    end

    render "scrollable_list" if params[:page]
  end


  def show
    @pagy, @comments = pagy_countless(@question.comments.order(created_at: :asc), items: 5)
    render "comments/scrollable_list" if params[:page]
    @answers = @question.answers.includes(:comments)
    @answer_id = params[:answer_id]
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash.now[:notice] = 'Pregunta creada correctamente'
      @pagy, @questions = pagy(Question.all.order(created_at: :desc))
      render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                 locals: { message: flash[:notice] }) +
                           turbo_stream.replace('questions_all', partial: 'questions/questions',
                                                                 locals: { questions: @questions })
    else
      flash.now[:alert] = 'No se ha podido crear la pregunta'
      render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                 locals: { message: flash[:alert] }) +
                           turbo_stream.replace('modal', partial: 'errors/new_question')
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
