class Api::V1::GameHolderSessionsController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :index, :create ]
  respond_to :json
  # GET /api/v1/reports
  def index
    params[:user_id] = @current_user.id
    list_response = GameHolderSession.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::ReportSerializer, meta: list_response.except!(:result), location: '/game_holder'
  end

  # GET /api/v1/reports/create
  # shows one report (based on the supplied id) 
  def create
    begin
      game_holder = GameHolder.find(params[:game_id] || params[:id])
      game_holder_session = game_holder.create_session(@current_user, params) 
      respond_with game_holder_session, serializer: Api::V1::ReportSerializer, location: '/game_holder'
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find Quiz with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # GET /api/v1/report/:id/details
  # shows one standard (based on the supplied id) 
  def details
    begin
      game_holder_session = GameHolderSession.find(params[:id])
      respond_with Api::V1::ReportSerializer.new(game_holder_session, {scope: @current_user})
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameLevel with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # PUT /api/v1/report/:id/
  # shows one standard (based on the supplied id) 
  def edit
    begin
      game_holder_session = GameHolderSession.find(params[:id])
      if params[:report_action]
        game_holder_session.change_status(params)
      else
        game_holder_session.update_attributes!(report_params)
      end
      render json: game_holder_session, serializer:  Api::V1::ReportSerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find GameLevel with 'id'=#{params[:id]}", :not_found) 
    end
  end

  private
  def report_params
    params.require(:game_holder_session).permit(:title)
  end
end
