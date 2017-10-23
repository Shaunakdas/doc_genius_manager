class Api::V1::StandardsController < Api::V1::ApiController
  respond_to :json
  # GET /api/v1/standards
  def index
    standard_list = Standard.all
    if params["search"]
      query = params["search"]
      standard_list = Standard.search(params[:search]).order('created_at DESC')
    elsif params["slug"]
      query = params["slug"]
      standard_list = Standard.search_slug(params[:slug]).order('created_at DESC')
    end
    total_count = standard_list.count
    page_num = (params.has_key?("page"))? (params["page"].to_i-1):(0)
    limit = (params.has_key?("limit"))? (params["limit"].to_i):(10)
    # puts "Page Number"+page_num.to_s
    # puts "Limit"+page_num.to_s
    standard_list = standard_list.drop(page_num * limit).first(limit)
    respond_with standard_list, each_serializer: Api::V1::StandardSerializer, meta: { total_count: total_count, page: page_num+1, limit: limit, search: query}, location: '/standard'
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
