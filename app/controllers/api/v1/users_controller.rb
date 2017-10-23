module Api::V1
  class UsersController < ApiController
    respond_to :json
    # GET /api/v1/users
    def index
      user_list = User.all
      if params["search"]
        query = params["search"]
        user_list = User.search(params[:search]).order('created_at DESC')
      elsif params["email"]
        query = params["email"]
        user_list = User.search_email(params[:email]).order('created_at DESC')
      end
      total_count = user_list.count
      page_num = (params.has_key?("page"))? (params["page"].to_i-1):(0)
      limit = (params.has_key?("limit"))? (params["limit"].to_i):(10)
      # puts "Page Number"+page_num.to_s
      # puts "Limit"+page_num.to_s
      user_list = user_list.drop(page_num * limit).first(limit)
      respond_with user_list, each_serializer: Api::V1::UserSerializer, meta: { total_count: total_count, page: page_num+1, limit: limit, search: query}, location: '/user'
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
          # puts "Update method: updated user"+user.to_json
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

    private

    def user_params
      params.require(:user).permit(:first_name, :email, :last_name, :password, :password_confirmation)
    end
  end
end