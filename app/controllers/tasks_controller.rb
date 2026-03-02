# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]
  before_action :authorize_task_owner!, only: %i[destroy]

  def index
    tasks = current_user.accessible_tasks
    render json: tasks
  end

  def show
    render json: @task
  end

  def create
    task = current_user.tasks.build(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = current_user.accessible_tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Not Found" }, status: :not_found
  end

  def authorize_task_owner!
    return if @task.user_id == current_user.id

    render json: { error: "Only the task owner can delete the task" }, status: :forbidden
  end

  def task_params
    params.permit(:title, :description, :completed, :priority)
  end
end
