module Api::V1
  class ApiController < ApplicationController
    # Generic API stuff here
    include ActionController::Serialization
    require 'json_web_token'
    attr_reader :current_user
    after_action :set_cors_headers

    def add_verification_code(params)
      params[:user][:verification_code] = [*1..9].sample(6)
    end

    def error_params(message)
      return {error: message}
    end

    def error_response(message, status = :ok)
      render json: {error: message}, status: status
    end

    def error_type_response(message, status = :ok, type)
      render json: {error: message, error_type: type}, status: status
    end

    def success_response(message, status = :ok, payload={})
      render json: {success: message, payload: payload}, status: status
    end

    def json_response(object, status = :ok)
      render json: object, status: status
    end


    protected
    def authenticate_request!
      unless user_id_in_token?
        render json: { error: ['Not Authenticated'] }, status: :unauthorized
        return
      end
      @current_user = User.find(auth_token[:user_id])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: ['Not Authenticated'] }, status: :unauthorized
    end

    private
    def http_token
        http_token ||= if request.headers['Authorization'].present?
          request.headers['Authorization'].split(' ').last
        end
    end

    def auth_token
      auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
    end

    def set_cors_headers
      response.set_header('Access-Control-Allow-Credentials', 'true')
      response.set_header('Access-Control-Allow-Headers', 'Accept, X-Access-Token, X-Application-Name, X-Request-Sent-Time')
      response.set_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      response.set_header('Access-Control-Allow-Origin', '*')
    end
  end
end