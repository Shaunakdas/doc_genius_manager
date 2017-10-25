module Api::V1
  class RegistrationsController < ApiController
    respond_to :json
    # post "sign_up/number"
    def sign_up_number
      begin
        add_verification_code(params)
        puts '1'
        user = User.new(user_params)
        puts '2'
        user.save! 
        puts '3'
        user.send_otp
        puts '4'
        puts user.to_json
        success_response("OTP sent to #{user.mobile_number}")
      rescue Exception => e
        puts "caught exception #{e}! ohnoes!"
      rescue ActiveRecord::RecordInvalid => invalid
        puts user.errors
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # post "activate"
    def activate
      render json: {}
    end
    
    # put "fill_form"
    def update
      render json: {}
    end
    
    # post "login/number"
    def login_number
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
  end
end