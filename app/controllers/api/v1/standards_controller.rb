class Api::V1::StandardsController < Api::V1::ApiController
  respond_to :json
  # GET /api/v1/standards
  def index
    list_response = Standard.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::StandardSerializer, meta: list_response.except!(:result), location: '/standard'
  end

  # POST /api/v1/standard
  def create
    begin
      standard = Standard.new(standard_params)
      standard.save! 
      respond_with standard, serializer: Api::V1::StandardSerializer, location: '/standard'
    rescue ActiveRecord::RecordInvalid => invalid
      error_response(standard.errors.full_messages[0], :unprocessable_entity) 
    rescue ActiveRecord::RecordNotUnique => invalid
      error_response(standard.errors.full_messages[0],  :conflict) 
    end
  end

  # GET /api/v1/standard
  # shows one standard (based on the supplied id) 
  def details
    begin
      standard = Standard.find(params[:id]) 
        # puts "Update method: updated standard"+standard.to_json
      respond_with standard, serializer: Api::V1::StandardSerializer
    rescue ActiveRecord::RecordNotFound
      error_response("Couldn't find Standard with 'id'=#{params[:id]}", :not_found) 
    end
  end

  # PUT /api/v1/standard
  def update
    if params[:id]
      begin
        standard = Standard.find(params[:id])  
        standard.update_attributes!(standard_params)
        respond_with standard, serializer: Api::V1::StandardSerializer
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find Standard with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(standard.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("No id is present") 
    end
  end

  # DELETE /api/v1/standard
  def delete
    if params[:id]
      begin
        standard  = Standard.find(params[:id])      
        standard.destroy!
        success_response("Standard with 'id'=#{params[:id]} deleted successfully")
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find Standard with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(standard.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("No id is present") 
    end
  end

  private

  def standard_params
    params.require(:standard).permit(:name, :slug)
  end
end