# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_task
  before_action :set_comment, only: %i[show update destroy]
  before_action :authorize_comment_owner!, only: %i[update destroy]

  def index
    comments = @task.comments.includes(:user).order(created_at: :asc)
    render json: comments.as_json(include: { user: { only: %i[id email] } })
  end

  def show
    render json: @comment.as_json(include: { user: { only: %i[id email] } })
  end

  def create
    comment = @task.comments.build(comment_params.merge(user: current_user))
    if comment.save
      render json: comment.as_json(include: { user: { only: %i[id email] } }), status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment.as_json(include: { user: { only: %i[id email] } })
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_task
    @task = current_user.accessible_tasks.find(params[:task_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  def authorize_comment_owner!
    return if @comment.user_id == current_user.id

    render json: { error: "Forbidden - you can only edit or delete your own comments" }, status: :forbidden
  end

  def comment_params
    params.permit(:content)
  end
end
