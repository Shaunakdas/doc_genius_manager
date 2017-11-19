module Api::V1
  class GameSessionsController < ApiController
    before_action :authenticate_request!, :only => [ :show ]
    respond_to :json
    # GET /api/v1/game_sessions
    def index
      list_response = GameSession.list(params)
      respond_with list_response[:result], each_serializer: GameSessionSerializer, meta: list_response.except!(:result), location: '/game_session'
    end

    # POST /api/v1/game_session
    def create
      begin
        game_session = GameSession.new(game_session_params)
        game_session.save! 
        respond_with game_session, serializer: GameSessionSerializer, location: '/game_session'
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(game_session.errors.full_messages[0], :unprocessable_entity) 
      rescue ActiveRecord::RecordNotUnique => invalid
        error_response(game_session.errors.full_messages[0],  :conflict) 
      end
    end

    # GET /api/v1/game_session
    # shows one game_session (based on the supplied id) 
    def details
      begin
        game_session = GameSession.find(params[:id]) 
          # puts "Update method: updated game_session"+game_session.to_json
        respond_with game_session, serializer: GameSessionSerializer
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameSession with 'id'=#{params[:id]}", :not_found) 
      end
    end

    private
    def game_session_params
      params.require(:game_session).permit(:start, :finish, :game_holder_id, :user_id )
    end
  end
end
