module Api::V1
  class UsersController < ApiController
    respond_to :json
    # GET /api/v1/users
    def index
      user_list = User.all
      
      respond_with User.all, each_serializer: Api::V1::UserSerializer, location: '/user'
    end

    # POST /api/v1/user
    def create
      begin
        user = User.new(user_params)
        user.save! 
        respond_with user, serializer: Api::V1::UserSerializer, location: '/user'
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(user.errors.full_messages[0], :unprocessable_entity) 
      end
    end

    # GET /api/v1/user
    # shows one user (based on the supplied id) 
    def details
      begin
        user = User.find(params[:id]) 
          puts "Update method: updated user"+user.to_json
        respond_with user, serializer: Api::V1::UserSerializer
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
      end
    end

    # GET /api/v1/user/me
    def me
      respond_with user, serializer: Api::V1::UserSerializer
    end

    # PUT /api/v1/user
    def update
      if params[:id]
        begin
          user = User.find(params[:id])  
          user.update_attributes!(user_params)
          respond_with user, serializer: Api::V1::UserSerializer
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(user.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No id is present") 
      end
    end
    # POST /api/v1/user/invite
    def invite
      respond_with user, serializer: Api::V1::UserSerializer
    end
    # POST /api/v1/photo/upload
    def photo_upload
      respond_with user, serializer: Api::V1::UserSerializer
    end
    # DELETE /api/v1/user
    def delete
      if params[:id]
        begin
          user  = User.find(params[:id])      
          user.destroy!
          success_response("User with 'id'=#{params[:id]} deleted successfully")
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(user.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No id is present") 
      end
    end

    def show
      user = User.first
      respond_with user, serializer: Api::V1::UserSerializer
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :email, :last_name, :password, :password_confirmation)
    end
  end
end