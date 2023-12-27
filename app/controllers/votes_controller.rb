# frozen_string_literal: true
# rubocop:disable all
class VotesController < ApplicationController
  before_action :set_question, only: %i[create destroy]
  before_action :set_votable, only: %i[create destroy]
  def create
    @vote = @votable.votes.create(user_id: current_user.id)
    votable_type = @votable.class.name
    flash.now[:notice] = '¡Voto creado!'
    respond_to do |format|
      if votable_type == 'Question'
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                     locals: { message: flash[:notice] }) +
                               turbo_stream.replace('votes_question', partial: 'votes/votes_question',
                                                                      locals: { question: @question })
        end
      elsif votable_type == 'Answer'
        set_answer
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                     locals: { message: flash[:notice] }) +
                               turbo_stream.replace("votes_answer_#{@answer.id}", partial: 'votes/votes_answers',
                                                                                  locals: { question: @question, answer: @answer })
        end
      end
    end
  end

  def destroy
    votable_type = @votable.class.name
    @votable.votes.where(user_id: current_user.id).destroy_all
    flash.now[:notice] = '¡Voto deshecho!'
    respond_to do |format|
      if votable_type == 'Question'
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                     locals: { message: flash[:notice] }) +
                               turbo_stream.replace('votes_question', partial: 'votes/votes_question',
                                                                      locals: { question: @question })
        end
      elsif votable_type == 'Answer'
        set_answer
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('flash-messages', partial: 'shared/notifications',
                                                                     locals: { message: flash[:notice] }) +
                               turbo_stream.replace("votes_answer_#{@answer.id}", partial: 'votes/votes_answers',
                                                                                  locals: { question: @question, answer: @answer })
        end
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
