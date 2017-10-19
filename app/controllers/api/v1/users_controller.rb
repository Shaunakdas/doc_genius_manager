module Api::V1
  class UsersController < ApiController
    respond_to :json
    # GET /v1/users
    def index
      render json: User.all
    end

    def show
      user = User.first
      respond_with user, serializer: Api::V1::UserSerializer
    end
  end
end