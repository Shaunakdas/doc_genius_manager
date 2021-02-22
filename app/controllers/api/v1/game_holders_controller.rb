class Api::V1::GameHoldersController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :homepage, :result,:level_details, :level_result, :session_result, :index, :user_action ]
  respond_to :json
  # GET /api/v1/games
  def index
    params[:user_id] = @current_user.id
    list_response = GameHolder.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::GameHolderSummarySerializer, meta: list_response.except!(:result), location: '/game_holder'
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

  # GET /api/v1/game/level_result
  # uploads result of a game (based on the supplied id) 
  def session_result
    begin
      game_level = GameHolderSession.find(params[:game_id] || params[:id])
      game_session = nil
      ActiveRecord::Base.transaction do
        game_session = game_level.parse_result(@current_user, params)
      end
      respond_with game_session, serializer: Api::V1::GameEndSerializer, location: '/game_session'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:game_id] || params[:id]}", :not_found) 
    end
  end

  # POST /api/v1/game/upload_file
  # upload excel for game_holders
  def upload_file
    begin
      game_holder = GameHolder.find(params[:id])
      ParseQuizExcelWorker.perform_async(game_holder.id,params[:file_url])
      respond_with game_holder, serializer: Api::V1::GameHolderDetailSerializer, location: '/game_session'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # PUT /api/v1/game/:id/action/:action_type
  # upload excel for game_holders
  def user_action
    puts params
    begin
      game_holder = GameHolder.find(params[:id])
      game_holder.user_action(@current_user,params[:action_type])
      respond_with game_holder, serializer: Api::V1::GameHolderSerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # POST /api/v1/game/
  # create game_holder 
  def create
    game = PracticeType.find_by(slug: "agility")
    game_holder = GameHolder.create!(:title => params[:title],name: params[:title], game: game,
      slug: params[:title].parameterize(separator: '-')+'-'+((0...6).map { ('a'..'z').to_a[rand(26)] }.join))
    respond_with game_holder, serializer: Api::V1::GameHolderDetailSerializer, location: '/game_session'
  end

  # PUT /api/v1/game/:id/
  # update game_holder
  def update
    begin
      game_holder = GameHolder.find(params[:id])
      game_holder.update_attributes!(game_holder_params)
      respond_with game_holder, serializer: Api::V1::GameHolderSummarySerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameHolder with 'id'=#{params[:id]}", :not_found) 
    end
  end

  private

  def game_holder_params
    params.require(:game_holder).permit(:name, :slug, :title, :image_url)
  end
end
