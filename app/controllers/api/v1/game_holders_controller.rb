class Api::V1::GameHoldersController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :homepage, :result,:level_details, :level_result, :index ]
  respond_to :json
  # GET /api/v1/games
  def index
    params[:user_id] = @current_user.id
    list_response = GameHolder.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::GameHolderSerializer, meta: list_response.except!(:result), location: '/game_holder'
  end

  # GET /api/v1/game/:id/details
  # shows one standard (based on the supplied id) 
  def details
    begin
      game_holder = GameHolder.find(params[:id])
      respond_with game_holder, serializer: Api::V1::GameHolderDetailSerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # GET /api/v1/game/:id/level_details
  # shows one standard (based on the supplied id) 
  def level_details
    begin
      game_level = GameLevel.find(params[:id])
      respond_with Api::V1::GameLevelDetailSerializer.new(game_level, {scope: @current_user})
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameLevel with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # GET /api/v1/game/result
  # uploads result of a game (based on the supplied id) 
  def result
    begin
      game_holder = GameHolder.find(params[:game_id] || params[:id])
      game_session = game_holder.parse_result(@current_user, params)
      respond_with game_session, serializer: Api::V1::GameEndSerializer, location: '/game_session'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:game_id] || params[:id]}", :not_found) 
    end
  end

  # GET /api/v1/game/level_result
  # uploads result of a game (based on the supplied id) 
  def level_result
    begin
      game_level = GameLevel.find(params[:game_id] || params[:id])
      game_session = nil
      ActiveRecord::Base.transaction do
        game_session = game_level.parse_result(@current_user, params)
      end
      respond_with game_session, serializer: Api::V1::GameEndSerializer, location: '/game_session'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:game_id] || params[:id]}", :not_found) 
    end
  end

  private

  def standard_params
    params.require(:standard).permit(:name, :slug)
  end
end
