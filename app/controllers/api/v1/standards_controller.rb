class Api::V1::StandardsController < Api::V1::ApiController
  before_action :authenticate_request!, :only => [ :homepage, :level_map, :streamwise_questions ]
  respond_to :json
  # GET /api/v1/standards
  def index
    list_response = Standard.list(params)
    respond_with list_response[:result], each_serializer: Api::V1::StandardOptionSerializer, meta: list_response.except!(:result), location: '/standard'
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

  # GET /api/v1/homepage
  # shows one standard (based on the supplied id) 
  def homepage
    if @current_user
      begin
        if !@current_user.standard
          error_type_response("User has not set his standard", :not_found, "standard_not_set")
        else
          respond_with @current_user, serializer: Api::V1::HomepageSerializer
        end
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(@current_user.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("Auth Token is not valid") 
    end
  end

  # GET /api/v1/map
  # shows one standard (based on the supplied id) 
  def level_map
    jump = false
      if @current_user
        puts current_user.id
        begin
          if !params[:topic_id].nil?
            topic = Topic.find(params[:topic_id])
            topic.set_fresh_standing(@current_user)
          else
            topic_stading = @current_user.topic_standing
            Standard.find(1).set_fresh_standing(@current_user) if topic_stading.nil?
            topic = @current_user.topic_standing.acad_entity
            jump = topic.reset_jump(@current_user)
          end
          scope = {
            topic_id: topic.id,
            jump: jump
          }
          respond_with Api::V1::LevelMapSerializer.new(@current_user, {scope: scope})
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(@current_user.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("Auth Token is not valid") 
    end
  end

  # GET /api/v1/question_types/all
  # shows one standard (based on the supplied id) 
  def streamwise_questions
    if @current_user
      begin
        render json: {streams: @current_user.standard.streamwise_questions}
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find User with 'id'=#{params[:id]}", :not_found) 
      rescue ActiveRecord::RecordInvalid => invalid
        error_response(@current_user.errors.full_messages[0], :unprocessable_entity) 
      end
    else
      error_response("Auth Token is not valid") 
    end
  end

  # GET /api/v1/home
  # shows new homepage 
  def home
    subject = Subject.where(slug: params[:subject]).first if params.has_key?("subject")
    standard = Standard.where(slug: params[:standard]).first if params.has_key?("standard") && (params[:standard].is_a? (String))
    chapter = Chapter.where(slug: params[:chapter]).first if params.has_key?("chapter")
    topic = Topic.where(slug: params[:topic]).first if params.has_key?("topic")
    sub_topic = SubTopic.where(slug: params[:sub_topic]).first if params.has_key?("sub_topic")
    
    if !sub_topic.nil?
      entity = sub_topic
    elsif !topic.nil?
      entity = topic
    elsif !chapter.nil?
      entity = chapter
    elsif !subject.nil?
      entity = subject
    elsif !standard.nil?
      entity = standard
    end
    
    if entity.nil?
      # Homepage
      child_entities = Subject.where(name: ["Maths", "English","Science"])
    elsif chapter.nil? && topic.nil? && sub_topic.nil?
      # Only Subject is given
      child_entities = entity.child_entities if standard.nil?
      if subject.nil?
        # Only Standard is given
        child_entities = Subject.where(name: ["Maths", "English","Science"]) if (standard.name.to_i<9)
        child_entities = Subject.where(name: ["Maths", "English","Physics", "Chemistry", "Biology"]) if (standard.name.to_i>8)
        standard_id = standard.slug
      end
      # If Subject and Standard are given
      child_entities = subject.chapters.where(standard: standard).where(enabled: true) if subject && standard
      
    else
      # Child Entities
      child_entities = entity.child_entities
    end
    respond_with child_entities, each_serializer: Api::V1::QuizBlockSerializer, scope: { standard_id: standard_id}
  end

  private

  def standard_params
    params.require(:standard).permit(:name, :slug)
  end
end
