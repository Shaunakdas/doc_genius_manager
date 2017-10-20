module Api::V1
  class ApiController < ApplicationController
    # Generic API stuff here
    include ActionController::Serialization
    def error_params(message)
      return {error: message}
    end
    def error_response(message, status = :ok)
      render json: {error: message}, status: status
    end
    def success_response(message, status = :ok)
      render json: {success: message}, status: status
    end

    def json_response(object, status = :ok)
      render json: object, status: status
    end
  end
end