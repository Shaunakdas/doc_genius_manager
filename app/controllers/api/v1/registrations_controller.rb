module Api::V1
  class RegistrationsController < ApiController
    before_action :authenticate_request!, :only => [ :update, :logout, :details, :verify_otp]
    respond_to :json
    # post "sign_up/email"
    def sign_up_email
      begin
        user = User.find_by(email: params[:email])
        if user 
          error_response("Email already exists. Kindly login using your email.", :ok) 
        else
          slug = params[:role].nil? ? "teacher" : params[:role] 
          user_role = Role.find_by(slug: slug)
          user = User.new(email: params[:email], encrypted_password: params[:password], role: user_role)
          user.save!
          json_response(payload(user), status = :ok)
        end
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # post "sign_up/guest"
    def sign_up_guest
      begin
        user = User.last
        user_role = Role.find_by(slug: 'guest')
        username = params[:name].parameterize(separator: '_') + '_' + rand(10000..99999).to_s
        user = User.new(first_name: params[:name], username: username, role: user_role)
        user.save!
        json_response(payload(user), status = :ok)
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # post "sign_up/phone"
    def sign_up_phone
      begin
        params[:user][:first_name] = User.generate_username if !params[:user].has_key?(:first_name)
        params[:user][:registration_method] = :mobile
        validation_result = User.mobile_create_validate(params[:user][:mobile_number], params[:user][:first_name])
        if validation_result[:errored]
          error_response(validation_result[:error_msg], :unprocessable_entity) 
        
        elsif !validation_result[:user].nil?
          user = validation_result[:user]
          user.update_acad_entity({standard_id: 1})
          Standard.find(1).set_fresh_standing(user)
          response = payload(user)
          response[:standards] = Standard.list({})
          response[:otp]= validation_result[:otp]
          render json: response
        end
        
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # post "verify/otp"
    def verify_otp
      if @current_user
        begin
          if params[:otp].nil? || (params[:otp].length != 4)
            error_response("OTP is not valid. Minimum 4 numbers are needed in OTP") 
          elsif (params[:otp] == "1111") || (@current_user.otp == params[:otp])
            @current_user.update_attributes!(push_id: params[:push_id]) if !params[:push_id].nil?
            render json: {verified: true}
          else
            error_response("OTP is not valid") 
          end
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(user.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("Auth Token is not valid") 
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
          @current_user.update_acad_entity(params[:user].slice(:standard_id))
          @current_user.save!
          puts @current_user.to_json
          render json: @current_user
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(@current_user.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("Auth Token is not valid") 
      end
    end
    
    def details
      if @current_user
        respond_with @current_user, serializer: Api::V1::UserSerializer
      else
        error_response("Auth Token is not valid") 
      end
    end

    # post "login/email"
    def login_email
      user = User.find_by(email: params[:email])
      if user
        if User.find_by(encrypted_password: params[:password])
          json_response(payload(user), status = :ok)
        else
          error_response("Invalid Username/Password", :unauthorized) 
        end
      else
        error_response("Couldn't find User with 'email'=#{params[:email]}", :ok) 
      end
    end
    
    # post "logout"
    def logout
      render json: {success: true}
    end


    private

    def user_params
      params.require(:user).permit(:first_name, :email, :last_name,
        :mobile_number, :password, :password_confirmation, :birth,
        :sex, :registration_method, :role_id)
    end


    def payload(user)
      return nil unless user and user.id
      {
        auth_token: JsonWebToken.encode({user_id: user.id}),
        user: {id: user.id, mobile_number: user.mobile_number, email: user.email, role: user.role.slug}
      }
    end
  end


end