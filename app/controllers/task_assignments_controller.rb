# frozen_string_literal: true

class TaskAssignmentsController < ApplicationController
  before_action :set_task
  before_action :authorize_task_owner!, only: %i[create destroy]

  def index
    assignees = @task.assignees
    render json: assignees, only: %i[id email created_at]
  end

  def create
    assignment = @task.task_assignments.build(user_id: params[:user_id])
    if assignment.save
      render json: { message: "User assigned to task" }, status: :created
    else
      render json: assignment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    assignment = @task.task_assignments.find_by!(user_id: params[:id])
    assignment.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Assignment not found" }, status: :not_found
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def authorize_task_owner!
    return if @task.user_id == current_user.id

    render json: { error: "Only the task owner can manage assignments" }, status: :forbidden
  end
end
