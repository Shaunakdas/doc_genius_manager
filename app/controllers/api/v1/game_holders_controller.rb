class Api::V1::GameHoldersController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :homepage, :details, :result ]
  respond_to :json
  # # GET /api/v1/games
  # def index
  #   list_response = Standard.list(params)
  #   respond_with list_response[:result], each_serializer: Api::V1::StandardOptionSerializer, meta: list_response.except!(:result), location: '/standard'
  # end

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

  # GET /api/v1/game/result
  # uploads result of a game (based on the supplied id) 
  def result
    begin
      game_holder = GameHolder.find(params[:game_id])
      game_holder.parse_result(@current_user, params)
      respond_with game_holder, serializer: Api::V1::GameHolderSerializer, location: '/game_session'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
    end
  end

  private

  def standard_params
    params.require(:standard).permit(:name, :slug)
  end
end
