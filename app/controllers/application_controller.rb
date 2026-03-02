# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # allow_browser versions: :modern
  # stale_when_importmap_changes
  protect_from_forgery with: :null_session
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
