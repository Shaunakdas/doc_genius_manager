module Api::V1
  class RegistrationsController < ApiController
    before_action :authenticate_request!, :only => [ :update, :logout]
    respond_to :json
    # post "sign_up/number"
    def sign_up_email
      begin
        user = User.new(user_params)
        user.save! 
        render json: payload(user)
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # post "activate"
    def activate
      render json: {}
    end
    
    # put "fill_form"
    def update
      if @current_user
        begin
          @current_user.map_enums(params[:user])
          @current_user.update_attributes!(user_params)
          # puts @current_user.to_json
          respond_with @current_user, serializer: Api::V1::UserSerializer
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(@current_user.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("Auth Token is not valid") 
      end
    end
    
    # post "login/number"
    def login_email
      render json: {}
    end
    
    # post "logout"
    def logout
      render json: {}
    end


    private

    def user_params
      params.require(:user).permit(:first_name, :email, :last_name,
        :mobile_number, :password, :password_confirmation, :birth,
        :sex, :registration_method)
    end


    def payload(user)
      return nil unless user and user.id
      {
        auth_token: JsonWebToken.encode({user_id: user.id}),
        user: {id: user.id, email: user.email}
      }
    end
  end


end