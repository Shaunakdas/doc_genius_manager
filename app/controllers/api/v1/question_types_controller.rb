class Api::V1::QuestionTypesController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :show ]
  respond_to :json
  # GET /api/v1/question_types
  def index
    list_response = QuestionType.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::QuestionTypeSerializer, meta: list_response.except!(:result), location: '/question_type'
  end

  # POST /api/v1/question_type
  def create
    begin
      question_type = QuestionType.new(question_type_params)
      question_type.save! 
      respond_with question_type, serializer: Api::V1::QuestionTypeSerializer, location: '/question_type'
    rescue ActiveRecord::RecordInvalid => invalid
      error_response(question_type.errors.full_messages[0], :unprocessable_entity) 
    rescue ActiveRecord::RecordNotUnique => invalid
      error_response(question_type.errors.full_messages[0],  :conflict) 
    end
  end

  # GET /api/v1/question_type
  # shows one question_type (based on the supplied id) 
  def details
    begin
      question_type = QuestionType.find(params[:id]) 
        # puts "Update method: updated question_type"+question_type.to_json
      respond_with question_type, serializer: Api::V1::QuestionTypeSerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find QuestionType with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # PUT /api/v1/question_type
  def update
    if params[:id]
      begin
        question_type = QuestionType.find(params[:id])  
        question_type.update_attributes!(question_type_params)
        respond_with question_type, serializer: Api::V1::QuestionTypeSerializer
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find QuestionType with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(question_type.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("No id is present") 
    end
  end

  # DELETE /api/v1/question_type
  def delete
    if params[:id]
      begin
        question_type  = QuestionType.find(params[:id])      
        question_type.destroy!
        success_response("QuestionType with 'id'=#{params[:id]} deleted successfully")
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find QuestionType with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(question_type.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("No id is present") 
    end
  end

  # GET /api/v1/question_type/:id
  # shows one question_type (based on the supplied id) 
  def show
    if @current_user
      begin
        question_type = QuestionType.find(params[:id]) 
        respond_with question_type, root: "question_type", serializer: Api::V1::QuestionTypeShowSerializer, user: @current_user
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find QuestionType with 'id'=#{params[:id]}", :not_found) 
      end
    else
      error_response("Auth Token is not valid") 
    end
  end

  private

  def question_type_params
    params.require(:question_type).permit(:name, :slug, :sub_topic_id, :sequence, :image_url )
  end
end
