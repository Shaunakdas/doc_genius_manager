module Api::V1
  class PasswordsController < ApplicationController
    respond_to :json
    # POST /password/forgot
    def forgot
      if params[:email].blank? # check if email is present
        return render json: {error: 'Email not present'}
      end
  
      user = User.find_by(email: params[:email]) # if present find user by email
  
      if user.present?
        user.generate_password_token! #generate pass token
        # SEND EMAIL HERE
        render json: {status: 'ok', token: user.reset_password_token}, status: :ok
      else
        render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
      end
    end

    # PUT /password/reset
    def reset
      token = params[:token].to_s

      if params[:token].blank?
        return render json: {error: 'Token not present'}
      end

      user = User.find_by(reset_password_token: token)

      if user.present? && user.password_token_valid?
        if user.reset_password!(params[:password])
          render json: {status: 'ok'}, status: :ok
        else
          render json: {error: user.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
      end
    end
  end
end
