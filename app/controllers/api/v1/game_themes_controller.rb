module Api::V1
  class GameThemesController < ApiController
    before_action :authenticate_request!, only: [ :saved_list, :save ]
    respond_to :json
    # GET /api/v1/game_themes
    def index
      respond_with GameTheme.all, each_serializer: Api::V1::GameThemeSerializer, location: '/standard'
    end

    # GET /api/v1/game_themes/saved
    def saved_list
      # respond_with GameTheme.all, each_serializer: Api::V1::GameThemeSerializer, location: '/standard'
      respond_with GameTheme.all, each_serializer: Api::V1::GameThemeSerializer, scope: { user_id: @current_user.id}
    end

    # PUT /api/v1/game_theme/:id/save
    def save
      puts params
      begin
        game_theme = GameTheme.find(params[:id])
        user_game_theme = UserGameTheme.create(user: @current_user, game_theme: game_theme)
        render json: {status: 'ok'}, status: :ok
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
      end
    end

  end
end
