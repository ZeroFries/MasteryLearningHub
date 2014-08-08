class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
  	User.first
  end

  rescue_from ActiveRecord::UnknownAttributeError, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, with: :render_json_model_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_json_not_found_error

	protected

	def render_json_model_error(exception)
		render json: {
			message: "Server error: #{exception.to_s}"
		}, status: :internal_server_error
	end

	def render_json_not_found_error(exception)
		render json: {
			message: "Not found: #{exception.to_s}"
		}, status: :not_found
	end
end
